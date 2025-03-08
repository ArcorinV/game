import 'package:equatable/equatable.dart';

// —- Events —-

sealed class GameEvent extends Equatable {
  const GameEvent();

  const factory GameEvent.loadHero({required int heroID}) = LoadHeroEvent;
  const factory GameEvent.battle({required int heroID}) = BattleEvent;
  const factory GameEvent.reviveHero({required int heroID}) = ReviveHeroEvent;
}

// —- Event's helper classes —-

class LoadHeroEvent extends GameEvent {
  final int heroID;

  const LoadHeroEvent({required this.heroID});

  @override
  List<Object> get props => [heroID];
}

class BattleEvent extends GameEvent {
  final int heroID;

  const BattleEvent({required this.heroID});

  @override
  List<Object> get props => [heroID];
}

class ReviveHeroEvent extends GameEvent {
  final int heroID;

  const ReviveHeroEvent({required this.heroID});

  @override
  List<Object> get props => [heroID];
}

// —- Event's base class —-

extension GameEventMap on GameEvent {
  R map<R>({
    required GameEventMatch<R, LoadHeroEvent> loadHero,
    required GameEventMatch<R, BattleEvent> battle,
    required GameEventMatch<R, ReviveHeroEvent> reviveHero,
  }) =>
      switch (this) {
        final LoadHeroEvent s => loadHero(s),
        final BattleEvent s => battle(s),
        final ReviveHeroEvent s => reviveHero(s),
      };
}

typedef GameEventMatch<R, E extends GameEvent> = R Function(E event);
