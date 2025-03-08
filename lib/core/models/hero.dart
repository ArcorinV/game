import 'package:game/core/models/armor/armor.dart';

class HeroModel {
  final int id;
  int level;
  int experience;
  List<ArmorModel>? armors;

  /// Battle
  int health = 100;
  bool isAlive = true;
  int defense = 0;

  int gold = 0;

  HeroModel({this.id = 1, required this.level, required this.experience, this.armors, this.gold = 0});

  void addExperience(int exp) {
    experience += exp;
    while (experience >= experienceToNextLevel()) {
      experience -= experienceToNextLevel();
      level++;
    }
  }

  // Пример формулы для расчета опыта до следующего уровня
  int experienceToNextLevel() => level * 100;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'experience': experience,
      'gold': gold,
    };
  }

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    return HeroModel(
      id: map['id'],
      level: map['level'],
      experience: map['experience'],
      gold: map['gold'],
    );
  }

  addArmor(List<ArmorModel> armors) {
    if (this.armors == null) {
      this.armors = [];
    }
    this.armors!.addAll(armors);
  }
}
