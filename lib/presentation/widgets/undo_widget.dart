import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/business_logic/grid_cubit/grid_cubit.dart';

class UndoWidget extends StatelessWidget {
  const UndoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<GridCubit>().undo();
      },
      icon: const Icon(
        Icons.undo,
        size: 40,
      ),
    );
  }
}
