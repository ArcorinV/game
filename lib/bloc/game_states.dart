import 'package:equatable/equatable.dart';
import 'package:game/core/models/armor/armor.dart';
import 'package:game/core/models/hero.dart';

// —- States —-
sealed class GameState extends Equatable {
  final HeroModel? hero;

  const GameState({this.hero});

  HeroModel get getHero {
    if (hero == null) throw Exception('No hero in state');
    return hero!;
  }

  const factory GameState.initial() = GameInitial;
  const factory GameState.heroLoaded({required HeroModel hero}) = HeroLoadedState;
  const factory GameState.battleCompleted({
    required HeroModel hero,
    required ArmorModel armor,
    required int experience,
  }) = BattleCompletedState;
  const factory GameState.newLevel({required HeroModel hero}) = NewLevelState;

  GameState init() => GameState.initial();
  GameState heroLoaded({required HeroModel hero}) => GameState.heroLoaded(hero: hero);
  GameState battleCompleted({required HeroModel hero, required ArmorModel armor, required int experience}) =>
      GameState.battleCompleted(hero: hero, armor: armor, experience: experience);
  GameState newLevel({required HeroModel hero}) => GameState.newLevel(hero: hero);
  GameState error({required String message}) => GameErrorState(message: message, hero: hero);
}

// —- States's helper classes —-
class GameInitial extends GameState {
  const GameInitial();

  @override
  get getHero => throw Exception('No hero in initial state');

  @override
  List<Object?> get props => [hero];
}

class HeroLoadedState extends GameState {
  const HeroLoadedState({required HeroModel hero}) : super(hero: hero);

  @override
  List<Object> get props => [hero!];
}

class BattleCompletedState extends GameState {
  final ArmorModel armor;
  final int experience;

  const BattleCompletedState({required HeroModel hero, required this.armor, required this.experience})
      : super(hero: hero);

  @override
  List<Object> get props => [hero!, armor, experience];
}

class GameErrorState extends GameState {
  final String message;

  const GameErrorState({required this.message, super.hero});

  @override
  get getHero {
    if (hero == null) throw Exception('No hero in error state');
    return hero!;
  }

  @override
  List<Object> get props => [message];
}

class NewLevelState extends GameState {
  const NewLevelState({required HeroModel hero}) : super(hero: hero);

  @override
  List<Object> get props => [hero!];
}

extension GameStateMap on GameState {
  R map<R>({
    required GameStateMatch<R, GameInitial> init,
    required GameStateMatch<R, HeroLoadedState> heroLoaded,
    required GameStateMatch<R, BattleCompletedState> battleCompleted,
    required GameStateMatch<R, NewLevelState> newLevel,
    required GameStateMatch<R, GameErrorState> error,
  }) =>
      switch (this) {
        final GameInitial s => init(s),
        final HeroLoadedState s => heroLoaded(s),
        final BattleCompletedState s => battleCompleted(s),
        final NewLevelState s => newLevel(s),
        final GameErrorState s => error(s),
      };

  R maybeMap<R>({
    required R Function() orElse,
    GameStateMatch<R, GameInitial>? init,
    GameStateMatch<R, HeroLoadedState>? heroLoaded,
    GameStateMatch<R, BattleCompletedState>? battleCompleted,
    GameStateMatch<R, NewLevelState>? newLevel,
    GameStateMatch<R, GameErrorState>? error,
  }) =>
      map<R>(
        init: init ?? (_) => orElse(),
        heroLoaded: heroLoaded ?? (_) => orElse(),
        battleCompleted: battleCompleted ?? (_) => orElse(),
        newLevel: newLevel ?? (_) => orElse(),
        error: error ?? (_) => orElse(),
      );

  R? mapOrNull<R>({
    GameStateMatch<R, GameInitial>? init,
    GameStateMatch<R, HeroLoadedState>? heroLoaded,
    GameStateMatch<R, BattleCompletedState>? battleCompleted,
    GameStateMatch<R, NewLevelState>? newLevel,
    GameStateMatch<R, GameErrorState>? error,
  }) =>
      map<R?>(
        init: init ?? (_) => null,
        heroLoaded: heroLoaded ?? (_) => null,
        battleCompleted: battleCompleted ?? (_) => null,
        newLevel: newLevel ?? (_) => null,
        error: error ?? (_) => null,
      );
}

// —- Helpers for matching —-
typedef GameStateMatch<R, S extends GameState> = R Function(S state);
