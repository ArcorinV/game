import 'package:flutter_application_1/bloc/game_events.dart';
import 'package:flutter_application_1/bloc/game_states.dart';
import 'package:flutter_application_1/core/hero.dart';
import 'package:flutter_application_1/db/database_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial()) {
    on<LoadHeroEvent>(_onLoadHero);
  }

  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<void> _onLoadHero(LoadHeroEvent event, Emitter<GameState> emit) async {
    try {
      HeroModel? hero = await dbHelper.getHero(event.heroId);
      if (hero == null) {
        hero = HeroModel(id: event.heroId, level: 1, experience: 0);
        await dbHelper.insertHero(hero);
      }
      emit(HeroLoadedState(hero: hero));
    } catch (e) {
      emit(GameErrorState(message: 'Failed to load hero'));
    }
  }
}
