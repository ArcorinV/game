import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/bloc/game_events.dart';
import 'package:game/bloc/game_states.dart';
import 'package:game/core/models/armor/armor.dart';
import 'package:game/core/models/hero.dart';
import 'package:game/data/database/database_helper.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<GameEvent>(
      (event, emit) => event.map(
        loadHero: (e) => _onLoadHero(e, emit),
        battle: (e) => _onBattle(e, emit),
        reviveHero: (e) => _onReviveHero(e, emit),
      ),
    );
    on<LoadHeroEvent>(_onLoadHero);
    on<BattleEvent>(_onBattle);
  }
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _onLoadHero(LoadHeroEvent event, Emitter<GameState> emit) async {
    try {
      HeroModel? hero = await dbHelper.getHero(event.heroID);
      if (hero == null) {
        hero = HeroModel(id: event.heroID, level: 1, experience: 0);
        await dbHelper.insertHero(hero);
      } else {
        final armor = await dbHelper.getArmors(hero.id);
        hero.armors = armor;
        final health = await dbHelper.getHeroStatus(hero.id);
        if (health != null) {
          hero.health = health;
          hero.isAlive = health > 0;
        }
      }
      emit(state.heroLoaded(hero: hero));
    } catch (e, st) {
      onError(e, st);
      emit(state.error(message: 'Failed to load hero'));
    }
  }

  Future<void> _onBattle(BattleEvent event, Emitter<GameState> emit) async {
    try {
      final hero = state.getHero;

      if (!hero.isAlive) {
        emit(GameErrorState(message: 'Revive your hero'));
        return;
      }

      List<DateTime> battles = await dbHelper.getHeroBattles(event.heroID);
      DateTime now = DateTime.now();

      // Check if the hero can battle
      if (battles.length >= 2 && battles.first.isAfter(now.subtract(Duration(days: 1)))) {
        emit(GameErrorState(message: 'You can only battle twice per day'));
        return;
      }

      if (battles.isNotEmpty && battles.first.isAfter(now.subtract(Duration(hours: 3)))) {
        emit(GameErrorState(message: 'You can only battle once every 3 hours'));
        return;
      }

      // Get random armor
      ArmorModel armor = ArmorModel.random();
      await dbHelper.insertHeroArmor(event.heroID, armor);
      hero.addArmor([armor]);

      final int experienceToNextLevel = hero.level * 100 - hero.experience;
      final int maxExperience = min(500, experienceToNextLevel);
      final int randomExperience = maxExperience > 50 ? 50 + Random().nextInt(maxExperience - 50 + 1) : maxExperience;

      hero.experience += randomExperience;
      if (hero.experience >= hero.level * 100) {
        hero.experience -= hero.level * 100;
        hero.level++;
        hero.health = 100;
        emit(NewLevelState(hero: hero));
      } else {}

      await dbHelper.updateHero(hero);
      await dbHelper.updateHeroHealth(hero.id, hero.health);
      await dbHelper.insertHeroBattle(event.heroID);

      emit(BattleCompletedState(hero: hero, armor: armor, experience: randomExperience));
    } catch (e) {
      emit(GameErrorState(message: 'Failed to complete battle \n$e'));
    }
  }

  Future<void> _onReviveHero(ReviveHeroEvent event, Emitter<GameState> emit) async {
    try {
      final hero = state.getHero;

      if (hero.isAlive) {
        emit(GameErrorState(message: 'Your hero is already alive', hero: state.hero));
        return;
      }

      final health = await dbHelper.getHeroStatus(hero.id);
      if (health != null) {
        hero.health = health;
        hero.isAlive = health > 0;
        // emit(HeroRevivedState(hero: hero));
      } else {
        emit(GameErrorState(message: 'Failed to revive hero', hero: state.hero));
      }
    } catch (e) {
      emit(GameErrorState(message: 'Failed to revive hero \n$e', hero: state.hero));
    }
  }
}
