import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/bloc/game_bloc.dart';
import 'package:game/bloc/game_events.dart';
import 'package:game/bloc/game_states.dart';
import 'package:game/core/models/hero.dart';
import 'package:game/features/main/pages/battle_page.dart';
import 'package:game/features/main/pages/inventory_page.dart';
import 'package:game/features/main/pages/settings_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  HeroModel? _hero;

  List<Widget> _widgetOptions() {
    return <Widget>[
      InventoryPage(hero: _hero!),
      BattlePage(hero: _hero!),
      SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc()..add(LoadHeroEvent(heroId: 1)),
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state is NewLevelState) {
            Flushbar(
              message: 'Congratulations! You have leveled up!',
              backgroundColor: Colors.green,
              margin: EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(10),
              duration: Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.TOP,
              icon: Icon(
                Icons.check,
                color: Colors.white,
              ),
              mainButton: TextButton(
                onPressed: () {
                  // Some code to execute.
                },
                child: Text(
                  'Awesome!',
                  style: TextStyle(color: Colors.yellow),
                ),
              ),
            ).show(context);
          }
        },
        builder: (context, state) {
          if (state is GameInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            _hero = state.hero;
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(widget.title),
              ),
              body: Center(
                child: _widgetOptions().elementAt(_selectedIndex),
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
                selectedItemColor: Colors.blue[700],
                onTap: _onItemTapped,
              ),
            );
          }
        },
      ),
    );
  }
}
