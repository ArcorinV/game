import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class LoadHeroEvent extends GameEvent {
  final int heroId;

  const LoadHeroEvent({required this.heroId});

  @override
  List<Object> get props => [heroId];
}

class GetRandomArmorEvent extends GameEvent {
  final int heroId;

  const GetRandomArmorEvent({required this.heroId});

  @override
  List<Object> get props => [heroId];
}

class GetRandomExperienceEvent extends GameEvent {
  final int heroId;

  const GetRandomExperienceEvent({required this.heroId});

  @override
  List<Object> get props => [heroId];
}

class BattleEvent extends GameEvent {
  final int heroId;

  const BattleEvent({required this.heroId});

  @override
  List<Object> get props => [heroId];
}
