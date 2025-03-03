import 'package:flutter/material.dart';
import 'package:game/core/models/hero.dart';

class InventoryPage extends StatelessWidget {
  final HeroModel hero;
  const InventoryPage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    final hasArmors = hero.armors != null && hero.armors!.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasArmors) const SizedBox(height: 20),
          Text('Уровень: ${hero.level}'),
          Text('Опыт: ${hero.experience}/${hero.experienceToNextLevel()}'),
          if (hero.armors != null && hero.armors!.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Text('Полученная броня:'),
            Expanded(
              child: ListView.builder(
                itemCount: hero.armors?.length,
                itemBuilder: (context, index) {
                  final armor = hero.armors![index];
                  return ListTile(
                    title: Text(
                      armor.name,
                      style: TextStyle(color: armor.getTextColor()),
                    ),
                    subtitle: Text('Защита: ${armor.defense}'),
                  );
                },
              ),
            ),
          ]
        ],
      ),
    );
  }
}
