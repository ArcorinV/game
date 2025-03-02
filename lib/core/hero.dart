class HeroModel {
  int? id;
  int level;
  int experience;

  HeroModel({this.id, required this.level, required this.experience});

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
}
