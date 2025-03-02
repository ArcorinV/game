import 'package:equatable/equatable.dart';
import 'package:flutter_application_1/core/hero.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class HeroLoadedState extends GameState {
  final HeroModel hero;

  const HeroLoadedState({required this.hero});

  @override
  List<Object> get props => [hero];
}

class GameErrorState extends GameState {
  final String message;

  const GameErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
