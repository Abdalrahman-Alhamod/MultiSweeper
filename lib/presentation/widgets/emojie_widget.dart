import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';
import 'package:minesweeper/helpers/app_images.dart';

class EmojieWidget extends StatelessWidget {
  const EmojieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GridCubit, GridState>(
      buildWhen: (previous, current) {
        return previous != current &&
            (current is GameOver || current is GameRestart);
      },
      builder: (context, state) {
        String imagePath = AppImages.smile;
        if (state is GameOver && !state.win) {
          imagePath = AppImages.sad;
        }
        return IconButton(
          onPressed: () {
            context.read<GridCubit>().restart();
          },
          icon: Image.asset(
            imagePath,
            width: 50,
            height: 50,
          ),
        );
      },
    );
  }
}
