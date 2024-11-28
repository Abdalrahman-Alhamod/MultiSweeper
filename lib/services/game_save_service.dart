import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:minesweeper/data/game_save.dart';
import 'package:minesweeper/data/grid_action.dart';

import '../data/game.dart';
import '../main.dart';

class GameSaveService {
  GameSaveService._internal();
  static final GameSaveService _singelton = GameSaveService._internal();
  factory GameSaveService() {
    return _singelton;
  }

  final String _savesName = "saves";

  Future<void> _saveGames(List<GameSave> gameSaves) async {
    final saves = gameSaves.map((e) => e.toJson()).toList();
    final result = await compute(jsonEncode, saves);
    await prefs.setString(_savesName, result);
  }

  Future<void> addGameSave(GameSave gameSave) async {
    List<GameSave> saves = await getAllGameSaves();
    saves.insert(0, gameSave);
    await _saveGames(saves);
  }

  Future<List<GameSave>> getAllGameSaves() async {
    final savedData = prefs.getString(_savesName);
    if (savedData == null || savedData.isEmpty) return [];
    final saves = await compute(jsonDecode, savedData);
    return (saves as List<dynamic>)
        .map((element) => GameSave.fromJson(element))
        .toList();
  }

  Future<void> saveGames(List<Game> games, String name) async {
    if (games.isEmpty || name.trim().isEmpty) {
      throw ArgumentError('Games list cannot be empty and name must be valid.');
    }
    GameSave save = GameSave(
      games: games,
      date: DateTime.now(),
      name: name,
      id: uuid.v4(),
    );
    await addGameSave(save);
  }

  Future<GameSave?> loadGame(String id) async {
    final saves = await getAllGameSaves();
    return saves.firstWhere((save) => save.id == id);
  }

  Future<void> deleteGame(String id) async {
    List<GameSave> saves = await getAllGameSaves();
    saves.removeWhere((save) => save.id == id);
    await _saveGames(saves);
  }
}
