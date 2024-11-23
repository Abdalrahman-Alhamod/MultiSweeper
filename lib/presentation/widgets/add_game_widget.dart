import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/game_cubit/game_cubit.dart';

class AddGameWidget extends StatelessWidget {
  const AddGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<GameCubit>().addGame();
      },
      icon: const Icon(
        Icons.add_circle_outline,
        size: 50,
      ),
    );
  }
}
