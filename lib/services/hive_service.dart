import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/data/game_save.dart';

import '../data/cell.dart';
import '../data/cell_content.dart';
import '../data/cell_status.dart';
import '../data/game.dart';
import '../data/grid.dart';
import '../data/position.dart';

class HiveService {
  HiveService._internal();
  static final HiveService _singelton = HiveService._internal();
  factory HiveService() {
    return _singelton;
  }

  String savesBoxName = "saves";

  Future<void> init() async {
    Hive.registerAdapter<Grid>(GridAdapter());
    Hive.registerAdapter<Cell>(CellAdapter());
    Hive.registerAdapter<Position>(PositionAdapter());
    Hive.registerAdapter<CellStatus>(CellStatusAdapter());
    Hive.registerAdapter<CellContent>(CellContentAdapter());
    Hive.registerAdapter<Game>(GameAdapter());
    Hive.registerAdapter<GameSave>(GameSaveAdapter());
    await Hive.openBox<GameSave>(savesBoxName);
  }
}
