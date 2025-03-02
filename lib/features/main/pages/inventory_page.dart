import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/hero.dart';

class InventoryPage extends StatelessWidget {
  final HeroModel hero;
  const InventoryPage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Уровень: ${hero.level}'),
          Text('Опыт: ${hero.experience}/${hero.experienceToNextLevel()}'),
          ElevatedButton(
            onPressed: () {
              hero.addExperience(50); // Добавить 50 опыта для теста
              (context as Element).markNeedsBuild(); // Обновить виджет
            },
            child: const Text('Получить опыт'),
          ),
        ],
      ),
    );
  }
}
