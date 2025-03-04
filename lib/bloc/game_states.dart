import 'package:equatable/equatable.dart';
import 'package:game/core/models/armor/armor.dart';
import 'package:game/core/models/hero.dart';

abstract class GameState extends Equatable {
  final HeroModel? hero;

  const GameState({this.hero});

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

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
  List<Object> get props => [message];
}

class NewLevelState extends GameState {
  const NewLevelState({required HeroModel hero}) : super(hero: hero);

  @override
  List<Object> get props => [hero!];
}
