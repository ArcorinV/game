import 'package:flutter/material.dart';
import 'package:game/core/models/armor/type_armor.dart';
import 'package:game/core/rarity.dart';

class ArmorModel {
  late String name;
  int defense = 10;
  final Rarity rarity;
  final TypeArmorWeight typeArmorWeight;
  final TypeArmor typeArmor;

  ArmorModel(
      {required this.name,
      required this.defense,
      required this.rarity,
      required this.typeArmorWeight,
      required this.typeArmor});

  ArmorModel.random()
      : rarity = Rarity.getRandom(),
        typeArmorWeight = TypeArmorWeight.randomTypeArmor,
        typeArmor = TypeArmor.randomTypeArmor {
    defense = _getDefense();
    name = _getName();
  }

  int _getDefense() {
    final rarityMultiplier = switch (rarity) {
      Rarity.common => 1,
      Rarity.uncommon => 1.5,
      Rarity.rare => 2,
      Rarity.epic => 2.5,
      Rarity.legendary => 3
    };
    final typeArmorWeightMultiplier = switch (typeArmorWeight) {
      TypeArmorWeight.light => 1,
      TypeArmorWeight.medium => 1.5,
      TypeArmorWeight.heavy => 2,
      TypeArmorWeight.shield => 1.5
    };
    final typeArmorMultiplier = switch (typeArmor) {
      TypeArmor.helmet => 1,
      TypeArmor.chestplate => 1.5,
      TypeArmor.leggings => 1.25,
      TypeArmor.boots => 1.1,
      TypeArmor.gloves => 1.1,
      TypeArmor.shield => 1.5
    };
    return (10 * rarityMultiplier * typeArmorWeightMultiplier * typeArmorMultiplier).toInt();
  }

  String _getName() {
    final rarityName = switch (rarity) {
      Rarity.common => 'Common',
      Rarity.uncommon => 'Uncommon',
      Rarity.rare => 'Rare',
      Rarity.epic => 'Epic',
      Rarity.legendary => 'Legendary'
    };
    final typeArmorWeightName = switch (typeArmorWeight) {
      TypeArmorWeight.light => 'Light',
      TypeArmorWeight.medium => 'Medium',
      TypeArmorWeight.heavy => 'Heavy',
      TypeArmorWeight.shield => ''
    };
    final typeArmorName = switch (typeArmor) {
      TypeArmor.helmet => 'Helmet',
      TypeArmor.chestplate => 'Chestplate',
      TypeArmor.leggings => 'Leggings',
      TypeArmor.boots => 'Boots',
      TypeArmor.gloves => 'Gloves',
      TypeArmor.shield => 'Shield'
    };
    return '$rarityName $typeArmorWeightName $typeArmorName';
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'defense': defense,
        'rarity': rarity.index,
        'typeArmorWeight': typeArmorWeight.index,
        'typeArmor': typeArmor.index
      };

  factory ArmorModel.fromMap(Map<String, dynamic> map) => ArmorModel(
      name: map['name'],
      defense: map['defense'],
      rarity: Rarity.values[map['rarity']],
      typeArmorWeight: TypeArmorWeight.values[map['type_armor_weight']],
      typeArmor: TypeArmor.values[map['type_armor']]);

  @override
  String toString() {
    return 'Armor{name: $name, defense: $defense, rarity: $rarity, typeArmorWeight: $typeArmorWeight, typeArmor: $typeArmor}';
  }

  Color? getTextColor() => switch (rarity) {
        Rarity.common => null,
        Rarity.uncommon => Colors.blue,
        Rarity.rare => Colors.green,
        Rarity.epic => Colors.purple,
        Rarity.legendary => Colors.orange
      };
}
