import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/game_bloc.dart';
import 'package:flutter_application_1/bloc/game_states.dart';
import 'package:flutter_application_1/core/hero.dart';
import 'package:flutter_application_1/features/main/pages/battle_page.dart';
import 'package:flutter_application_1/features/main/pages/inventory_page.dart';
import 'package:flutter_application_1/features/main/pages/settings_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_1/db/database_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  HeroModel? _hero;

  static final List<Widget> _widgetOptions = <Widget>[
    InventoryPage(),
    BattlePage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadHero();
  }

  Future<void> _loadHero() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    HeroModel? hero = await dbHelper.getHero(1);
    if (hero == null) {
      hero = HeroModel(id: 1, level: 1, experience: 0);
      await dbHelper.insertHero(hero);
    }
    setState(() {
      _hero = hero;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(InventoryState(hero: _hero)),
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) => {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory),
                label: 'Мой герой',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_martial_arts),
                label: 'Битва',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Настройки',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
