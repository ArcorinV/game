class HeroModel {
  int level = 1;
  int experience = 0;

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
}
