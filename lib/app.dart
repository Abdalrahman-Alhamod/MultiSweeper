import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/presentation/start_view.dart';

import 'business_logic/game_cubit/game_cubit.dart';

class MinesweeperApp extends StatelessWidget {
  const MinesweeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameCubit(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartView(),
      ),
    );
  }
}
