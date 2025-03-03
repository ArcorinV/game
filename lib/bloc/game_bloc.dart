import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/bloc/game_events.dart';
import 'package:game/bloc/game_states.dart';
import 'package:game/core/models/armor/armor.dart';
import 'package:game/core/models/hero.dart';
import 'package:game/data/database/database_helper.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<LoadHeroEvent>(_onLoadHero);
    on<BattleEvent>(_onBattle);
  }

  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _onLoadHero(LoadHeroEvent event, Emitter<GameState> emit) async {
    try {
      HeroModel? hero = await dbHelper.getHero(event.heroId);
      if (hero == null) {
        hero = HeroModel(id: event.heroId, level: 1, experience: 0);
        await dbHelper.insertHero(hero);
      } else {
        final armor = await dbHelper.getArmors(hero.id);
        hero.armors = armor;
      }
      emit(HeroLoadedState(hero: hero));
    } catch (e) {
      emit(GameErrorState(message: 'Failed to load hero'));
    }
  }

  Future<void> _onBattle(BattleEvent event, Emitter<GameState> emit) async {
    try {
      final hero = state.hero!;

      List<DateTime> battles = await dbHelper.getHeroBattles(event.heroId);
      DateTime now = DateTime.now();

      // // Check if the hero can battle
      // if (battles.length >= 2 && battles.first.isAfter(now.subtract(Duration(days: 1)))) {
      //   emit(GameErrorState(message: 'You can only battle twice per day', hero: state.hero));
      //   return;
      // }

      // if (battles.isNotEmpty && battles.first.isAfter(now.subtract(Duration(hours: 3)))) {
      //   emit(GameErrorState(message: 'You can only battle once every 3 hours', hero: state.hero));
      //   return;
      // }

      // Get random armor
      ArmorModel armor = ArmorModel.random();
      await dbHelper.insertHeroArmor(event.heroId, armor);
      hero.armors = [armor];

      final int experienceToNextLevel = hero.level * 100 - hero.experience;
      final int maxExperience = min(500, experienceToNextLevel - 1);
      final int randomExperience = 50 + Random().nextInt(maxExperience - 50 + 1);

      hero.experience += randomExperience;
      if (hero.experience >= hero.level * 100) {
        hero.experience -= hero.level * 100;
        hero.level++;
      }

      await dbHelper.updateHero(hero);
      await dbHelper.insertHeroBattle(event.heroId);

      emit(BattleCompletedState(hero: hero, armor: armor, experience: randomExperience));
    } catch (e) {
      emit(GameErrorState(message: 'Failed to complete battle \n$e', hero: state.hero));
    }
  }
}
