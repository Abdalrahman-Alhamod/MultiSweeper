import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/data/grid.dart';
import 'package:minesweeper/data/grid_action.dart';
import '../../data/game.dart';
part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit() : super(GridInitial());

  Game _game = Game();

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
          GridUpdate(
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
}
