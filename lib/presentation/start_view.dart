import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';
import 'package:minesweeper/helpers/app_images.dart';
import 'package:minesweeper/helpers/custom_elevated_button.dart';
import 'package:minesweeper/presentation/game_view.dart';
import 'package:minesweeper/presentation/load_game_view.dart';

class StartView extends StatelessWidget {
  const StartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              AppImages.grid,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomElevatedButton(
                  onPressed: () async {
                    context.read<GameCubit>().init(
                          rowsCount: 12,
                          columnsCount: 7,
                          minesCount: 10,
                        );
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GameView(),
                      ),
                    );
                  },
                  title: "New Game",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomElevatedButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoadGameView(),
                      ),
                    );
                  },
                  title: "Load Game",
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
