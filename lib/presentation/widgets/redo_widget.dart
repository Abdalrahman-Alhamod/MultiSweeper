import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/grid_cubit/grid_cubit.dart';

class RedoWidget extends StatelessWidget {
  const RedoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<GridCubit>().redo();
      },
      icon: const Icon(
        Icons.redo,
        size: 40,
      ),
    );
  }
}
