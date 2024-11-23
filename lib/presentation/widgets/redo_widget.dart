import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/game_cubit/game_cubit.dart';

class RedoWidget extends StatelessWidget {
  const RedoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<GameCubit>().redo();
      },
      icon: const Icon(
        Icons.redo,
        size: 40,
      ),
    );
  }
}
