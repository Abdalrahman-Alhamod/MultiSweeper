import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';
import 'package:minesweeper/helpers/app_images.dart';

class EmojieWidget extends StatelessWidget {
  const EmojieWidget({super.key, required this.gameId});
  final String gameId;
  @override
  Widget build(BuildContext context) {
    Color? topBorderColor = Colors.grey[100];
    Color? bottomBorderColor = Colors.grey[500];
    double borderWidth = 4;
    return BlocBuilder<GameCubit, GameState>(
      buildWhen: (previous, current) {
        return previous != current &&
            ((current is GameOver && current.gamdId == gameId) ||
                (current is GameRestart && current.gamdId == gameId));
      },
      builder: (context, state) {
        String imagePath = AppImages.smile;
        if (state is GameOver && !state.win) {
          imagePath = AppImages.sad;
        }
        return Material(
          child: InkWell(
            onTap: () => context.read<GameCubit>().restart(gameId),
            child: Ink(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: borderWidth,
                    color: topBorderColor!,
                  ),
                  left: BorderSide(
                    width: borderWidth,
                    color: topBorderColor,
                  ),
                  right: BorderSide(
                    width: borderWidth,
                    color: bottomBorderColor!,
                  ),
                  bottom: BorderSide(
                    width: borderWidth,
                    color: bottomBorderColor,
                  ),
                ),
                color: Colors.grey[400],
              ),
              child: Image.asset(
                imagePath,
                width: 36,
                height: 36,
              ),
            ),
          ),
        );
      },
    );
  }
}
