import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/presentation/home_view.dart';

import 'business_logic/grid_cubit/grid_cubit.dart';

class MinesweeperApp extends StatelessWidget {
  const MinesweeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GridCubit()
        ..init(
          rowsCount: 12,
          columnsCount: 7,
          minesCount: 10,
        ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}
