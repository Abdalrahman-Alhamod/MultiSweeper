import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../business_logic/game_cubit/game_cubit.dart';
import 'widgets/load_widget.dart';
import 'widgets/save_widget.dart';

import 'widgets/game_widget.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    final games = context.read<GameCubit>().games;
    return Scaffold(
      backgroundColor: Colors.grey[400],
      body: SafeArea(
        child: Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SaveWidget(),
                LoadWidget(),
              ],
            ),
            Expanded(
              child: BlocBuilder<GameCubit, GameState>(
                buildWhen: (previous, current) {
                  return previous != current && current is GameAdd;
                },
                builder: (context, state) {
                  return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) => GameWidget(
                      gameId: games[index].id,
                      isLastElement: index == games.length - 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
