import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/app.dart';
import 'package:minesweeper/helpers/custom_bloc_observer.dart';
import 'package:minesweeper/services/hive_service.dart';

void main() async {
  Bloc.observer = CustomBlocObserver();
  await Hive.initFlutter("Minesweeper");
  await HiveService().init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(
    const MinesweeperApp(),
  );
}
