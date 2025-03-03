import 'dart:math';

enum Rarity {
  common,
  uncommon,
  rare,
  epic,
  legendary;

  static getRandom() {
    final randomNumber = Random().nextInt(1000);
    if (randomNumber < 500) {
      return Rarity.common;
    } else if (randomNumber < 750) {
      return Rarity.uncommon;
    } else if (randomNumber < 900) {
      return Rarity.rare;
    } else if (randomNumber < 990) {
      return Rarity.epic;
    } else {
      return Rarity.legendary;
    }
  }
}
