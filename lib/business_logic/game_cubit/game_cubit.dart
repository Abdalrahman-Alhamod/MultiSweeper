import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/data/game_save.dart';
import 'package:minesweeper/data/grid.dart';
import 'package:minesweeper/data/grid_action.dart';
import 'package:minesweeper/services/game_save_service.dart';
import '../../data/game.dart';
part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial());

  late Game _game;
  final GameSaveService _gameSaveService = GameSaveService();

  void init({
    required int rowsCount,
    required int columnsCount,
    required int minesCount,
  }) {
    _game = Game.init(
      columnsCount: columnsCount,
      rowsCount: rowsCount,
      minesCount: minesCount,
      onUpdate: () {
        emit(
          GameUpdate(
            _game.grid,
            _game.grid.revealMines,
            _game.isGameOver,
            _game.flagsCount,
          ),
        );
      },
      onStart: () {
        emit(
          GameStart(),
        );
      },
      onWin: () {
        emit(
          GameOver(win: true),
        );
      },
      onLose: () {
        emit(
          GameOver(win: false),
        );
      },
      onRestart: () {
        emit(
          GameRestart(),
        );
      },
      onTimeUpdate: () {
        emit(
          GameTimeUpdate(
            _game.time,
          ),
        );
      },
    );
    _game.update();
  }

  void restart() {
    _game.restart();
  }

  void execute({required GridAction action}) {
    _game.execute(action: action);
  }

  void undo() {
    _game.undo();
  }

  void redo() {
    _game.redo();
  }

  void saveGame() async {
    if (!_game.isGameOver) {
      emit(GameSaveLoading());
      try {
        await _gameSaveService.saveGame(_game, "MySave");
        emit(GameSaveSuccess());
      } catch (e) {
        emit(GameSaveFailure(error: e.toString()));
      }
    }
  }

  List<GameSave> getAllGameSaves() {
    return _gameSaveService.getAllGameSaves().reversed.toList();
  }

  void loadGame({required String id}) {
    try {
      GameSave? loadedGame = _gameSaveService.loadGame(id);

      if (loadedGame == null) {
        emit(GameLoadFailure(error: "Save not found!"));
      } else {
        try {
          _game.dispose();
        } catch (_) {}
        _game = loadedGame.game;
        _game = Game.clone(_game);
        _game.setOnActions(
          onUpdate: () {
            emit(
              GameUpdate(
                _game.grid,
                _game.grid.revealMines,
                _game.isGameOver,
                _game.flagsCount,
              ),
            );
          },
          onStart: () {
            emit(
              GameStart(),
            );
          },
          onWin: () {
            emit(
              GameOver(win: true),
            );
          },
          onLose: () {
            emit(
              GameOver(win: false),
            );
          },
          onRestart: () {
            emit(
              GameRestart(),
            );
          },
          onTimeUpdate: () {
            emit(
              GameTimeUpdate(
                _game.time,
              ),
            );
          },
        );
        _game.resetActionsStacks();
        emit(GameLoadSuccess());
      }
    } catch (e) {
      emit(GameLoadFailure(error: e.toString()));
    }
  }

  void updateTimer() {
    emit(GameTimeUpdate(_game.time));
  }

  void updateGrid() {
    _game.update();
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
