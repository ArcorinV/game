import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game/bloc/game_bloc.dart';
import 'package:game/bloc/game_events.dart';
import 'package:game/bloc/game_states.dart';
import 'package:game/core/models/hero.dart';

class BattlePage extends StatelessWidget {
  final HeroModel hero;

  const BattlePage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state is GameErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(10),
            ),
          );
        } else if (state is BattleCompletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Received armor: ${state.armor}'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(10),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Received ${state.experience} experience'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(10),
            ),
          );
        }
      },
      builder: (context, state) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Битва'),
              ElevatedButton(
                onPressed: () {
                  context.read<GameBloc>().add(BattleEvent(heroId: hero.id));
                },
                child: const Text('Отправиться в битву'),
              ),
            ],
          ),
        );
      },
    );
  }
}
