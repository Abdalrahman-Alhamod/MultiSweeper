import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/game_save.dart';
import '../../data/grid.dart';
import '../../data/grid_action.dart';
import '../../services/game_save_service.dart';

import '../../data/game.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  late List<Game> games;
  final GameSaveService _gameSaveService = GameSaveService();

  void init({
    required int rowsCount,
    required int columnsCount,
    required int minesCount,
  }) {
    games = [];
    addGame();
  }

  void addGame() {
    String gameId = uuid.v4();
    Game game = Game.init(
      columnsCount: 7,
      rowsCount: 12,
      minesCount: 10,
      onUpdate: () {
        updateGrid(gameId);
      },
      onStart: () {
        emit(
          GameStart(gameId),
        );
      },
      onWin: () {
        emit(
          GameOver(win: true, gameId),
        );
      },
      onLose: () {
        emit(
          GameOver(win: false, gameId),
        );
      },
      onRestart: () {
        emit(
          GameRestart(gameId),
        );
      },
      onTimeUpdate: () {
        updateTimer(gameId);
      },
      id: gameId,
    );
    games.add(game);
    game.update();
    emit(GameAdd());
  }

  Game _getGameFromId(String gameId) {
    return games.firstWhere((game) => game.id == gameId);
  }

  void restart(String gameId) {
    Game game = _getGameFromId(gameId);
    game.restart();
  }

  void execute({required GridAction action, required String gameId}) {
    Game game = _getGameFromId(gameId);
    game.execute(action: action);
  }

  void undo(String gameId) {
    Game game = _getGameFromId(gameId);
    game.undo();
  }

  void redo(String gameId) {
    Game game = _getGameFromId(gameId);
    game.redo();
  }

  void updateTimer(String gameId) {
    Game game = _getGameFromId(gameId);
    emit(GameTimeUpdate(game.time, gameId));
  }

  void updateGrid(String gameId) {
    Game game = _getGameFromId(gameId);
    emit(
      GameUpdate(
        game.grid,
        game.grid.revealMines,
        game.isGameOver,
        game.flagsCount,
        gameId,
      ),
    );
  }

  void saveGame() async {
    emit(GameSaveLoading());
    try {
      await _gameSaveService.saveGames(games, "MySave");
      emit(GameSaveSuccess());
    } catch (e) {
      emit(GameSaveFailure(error: e.toString()));
    }
  }

  void getAllGameSaves() async {
    emit(FetchAllSavedGamesLoading());
    try {
      final savedGames = await _gameSaveService.getAllGameSaves();
      emit(FetchAllSavedGamesSuccess(savedGames));
    } catch (e) {
      emit(FetchAllSavedGamesFailure(error: e.toString()));
    }
  }

  void loadGame({required String id}) async {
    emit(GameLoadLoading());
    try {
      GameSave? loadedGame = await _gameSaveService.loadGame(id);

      if (loadedGame == null) {
        emit(GameLoadFailure(error: "Save not found!"));
      } else {
        try {
          for (Game game in games) {
            game.dispose();
          }
        } catch (_) {}
        games = [];
        final loadedGames = loadedGame.games;
        for (Game game in loadedGames) {
          final gameId = game.id;
          game.setOnActions(
            onUpdate: () {
              updateGrid(gameId);
            },
            onStart: () {
              emit(
                GameStart(gameId),
              );
            },
            onWin: () {
              emit(
                GameOver(win: true, gameId),
              );
            },
            onLose: () {
              emit(
                GameOver(win: false, gameId),
              );
            },
            onRestart: () {
              emit(
                GameRestart(gameId),
              );
            },
            onTimeUpdate: () {
              updateTimer(gameId);
            },
          );
          games.add(game);
        }
        emit(GameLoadSuccess());
      }
    } catch (e) {
      emit(GameLoadFailure(error: e.toString()));
    }
  }

  void deleteGame({required String id}) async {
    emit(GameDeleteLoading());
    try {
      await _gameSaveService.deleteGame(id);
      emit(GameDeleteSuccess());
    } catch (e) {
      emit(GameDeleteFailure(error: e.toString()));
    }
  }
}
