import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/app.dart';
import 'package:minesweeper/helpers/custom_bloc_observer.dart';


void main() {
  Bloc.observer = CustomBlocObserver();
  runApp(
    const MinesweeperApp(),
  );
}
