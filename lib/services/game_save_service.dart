import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/data/game_save.dart';
import 'package:minesweeper/data/grid_action.dart';
import 'package:minesweeper/services/hive_service.dart';

import '../data/game.dart';

class GameSaveService {
  GameSaveService._internal();
  static final GameSaveService _singelton = GameSaveService._internal();
  factory GameSaveService() {
    return _singelton;
  }

  final Box<GameSave> _gameSaveBox =
      Hive.box<GameSave>(HiveService().savesBoxName);

  Future<void> addGameSave(GameSave gameSave) async {
    await _gameSaveBox.add(gameSave);
  }

  GameSave? getGameSave(int index) {
    return _gameSaveBox.getAt(index);
  }

  Future<void> updateGameSave(int index, GameSave gameSave) async {
    await _gameSaveBox.putAt(index, gameSave);
  }

  Future<void> deleteGameSave(int index) async {
    await _gameSaveBox.deleteAt(index);
  }

  List<GameSave> getAllGameSaves() {
    return _gameSaveBox.values.toList();
  }

  Future<void> saveGame(Game game, String name) async {
    GameSave save = GameSave(
      game: Game.clone(game),
      date: DateTime.now(),
      name: name,
      id: uuid.v4(),
    );
    await addGameSave(save);
  }

  GameSave? loadGame(String id) {
    return _gameSaveBox.values.firstWhere((save) => save.id == id);
  }

  Future<void> deleteGame(String id) async {
    for (int i = 0; i < _gameSaveBox.length; i++) {
      if (_gameSaveBox.getAt(i)?.id == id) {
        await _gameSaveBox.deleteAt(i);
        return;
      }
    }
  }
}
