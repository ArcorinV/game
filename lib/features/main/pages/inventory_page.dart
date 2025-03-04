import 'package:flutter/material.dart';
import 'package:game/core/models/hero.dart';

class InventoryPage extends StatefulWidget {
  final HeroModel hero;
  const InventoryPage({super.key, required this.hero});

  @override
  InventoryPageState createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage> {
  bool _showArmors = true;

  @override
  Widget build(BuildContext context) {
    final hasArmors = widget.hero.armors != null && widget.hero.armors!.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (hasArmors) const SizedBox(height: 20),
          Text('Уровень: ${widget.hero.level}'),
          Text('Опыт: ${widget.hero.experience}/${widget.hero.experienceToNextLevel()}'),
          Text('Здоровье: ${(widget.hero.health / 10).floor()}/10'),
          Text('Защита: ${widget.hero.defense}'),
          if (hasArmors) ...[
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showArmors = !_showArmors;
                });
              },
              child: Text(_showArmors ? 'Скрыть броню' : 'Показать броню'),
            ),
            if (_showArmors) ...[
              const SizedBox(height: 20),
              const Text('Полученная броня:'),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.hero.armors?.length,
                  itemBuilder: (context, index) {
                    final armor = widget.hero.armors![index];
                    return ListTile(
                      title: Text(
                        armor.name,
                        style: TextStyle(color: armor.getTextColor()),
                      ),
                      subtitle: Text('Защита: ${armor.defense}'),
                      trailing: TextButton(onPressed: () {}, child: Text('Продать')),
                    );
                  },
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
