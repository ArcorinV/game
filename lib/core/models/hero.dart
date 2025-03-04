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

  HeroModel({this.id = 1, required this.level, required this.experience, this.armors});

  void addExperience(int exp) {
    experience += exp;
    while (experience >= experienceToNextLevel()) {
      experience -= experienceToNextLevel();
      level++;
    }
  }

  int experienceToNextLevel() {
    return level * 100; // Пример формулы для расчета опыта до следующего уровня
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'experience': experience,
    };
  }

  factory HeroModel.fromMap(Map<String, dynamic> map) {
    return HeroModel(
      id: map['id'],
      level: map['level'],
      experience: map['experience'],
    );
  }

  addArmor(List<ArmorModel> armors) {
    if (this.armors == null) {
      this.armors = [];
    }
    this.armors!.addAll(armors);
  }
}
