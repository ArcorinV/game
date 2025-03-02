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
