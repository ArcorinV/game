import 'package:flutter_application_1/hero.dart';

sealed class GameState {}

final class InventoryState extends GameState {
  final HeroModel hero;

  InventoryState({required this.hero});
}
