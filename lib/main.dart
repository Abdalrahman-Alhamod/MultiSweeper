import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/app.dart';
import 'package:minesweeper/data/cell.dart';
import 'package:minesweeper/data/cell_content.dart';
import 'package:minesweeper/data/cell_status.dart';
import 'package:minesweeper/data/grid.dart';
import 'package:minesweeper/data/position.dart';
import 'package:minesweeper/helpers/custom_bloc_observer.dart';

void main() async {
  Bloc.observer = CustomBlocObserver();
  await Hive.initFlutter();
  Hive.registerAdapter<Grid>(GridAdapter());
  Hive.registerAdapter<Cell>(CellAdapter());
  Hive.registerAdapter<Position>(PositionAdapter());
  Hive.registerAdapter<CellStatus>(CellStatusAdapter());
  Hive.registerAdapter<CellContent>(CellContentAdapter());
  await Hive.openLazyBox<Grid>("saves");

  runApp(
    const MinesweeperApp(),
  );
}
