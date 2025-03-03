import 'dart:math';

enum TypeArmorWeight {
  light,
  medium,
  heavy,
  shield;

  static get randomTypeArmor => values[Random().nextInt(values.length)];
}

enum TypeArmor {
  helmet,
  chestplate,
  leggings,
  boots,
  gloves,
  shield;

  static get randomTypeArmor => values[Random().nextInt(values.length)];
}
