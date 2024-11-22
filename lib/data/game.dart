import 'dart:math';
import 'package:minesweeper/data/grid.dart';
import 'package:minesweeper/data/grid_action.dart';
import 'package:minesweeper/data/position.dart';
import 'package:minesweeper/helpers/stack.dart';

class Game {
  late Grid grid;
  int minesCount;
  int usedFlagsCount;
  int saveCellsOpenedCount;
  bool isFirstCellOpened;
  bool isGameOver = false;
  DStack<GridAction> previousActions;
  DStack<GridAction> nextActions;
  final void Function() onStart;
  final void Function() onRestart;
  final void Function() onWin;
  final void Function() onLose;
  final void Function() onUpdate;

  Game()
      : onStart = (() {}),
        onRestart = (() {}),
        onWin = (() {}),
        onLose = (() {}),
        onUpdate = (() {}),
        minesCount = 0,
        usedFlagsCount = 0,
        saveCellsOpenedCount = 0,
        isGameOver = false,
        isFirstCellOpened = false,
        previousActions = DStack(),
        nextActions = DStack();

  Game.init({
    required int rowsCount,
    required int columnsCount,
    required this.minesCount,
    required this.onStart,
    required this.onRestart,
    required this.onWin,
    required this.onLose,
    required this.onUpdate,
  })  : grid = Grid.generate(rowsCount: rowsCount, columnsCount: columnsCount),
        previousActions = DStack(),
        nextActions = DStack(),
        usedFlagsCount = 0,
        saveCellsOpenedCount = 0,
        isGameOver = false,
        isFirstCellOpened = false;

  int get flagsCount => minesCount - usedFlagsCount;

  void plantMines({required Position exludedPosition}) {
    int plantedMines = minesCount;
    while (plantedMines > 0) {
      Random random = Random();
      int randomX = random.nextInt(grid.columnsCount);
      int randomY = random.nextInt(grid.rowsCount);
      if (!grid.getCell(randomX, randomY).isMined &&
          (randomX != exludedPosition.x || randomY != exludedPosition.y)) {
        grid.getCell(randomX, randomY).plantMine();
        plantedMines--;
        grid.runOnAdjacentCells(
          randomX,
          randomY,
          (cell) {
            if (!cell.isMined) {
              cell.incrementAdjacentMinesCount();
            }
          },
        );
      }
    }
  }

  void execute({required GridAction action}) {
    action.run(game: this);
    nextActions.clear();
    previousActions.push(action);
    update();
  }

  void undo() {
    if (previousActions.isEmpty || isGameOver) {
      return;
    }
    GridAction lastAction = previousActions.pop();
    nextActions.push(lastAction);
    lastAction.undo(game: this);
    update();
  }

  void redo() {
    if (nextActions.isEmpty || isGameOver) {
      return;
    }
    GridAction nextAction = nextActions.pop();
    previousActions.push(nextAction);
    nextAction.redo(game: this);
    update();
  }

  bool checkWin() {
    return saveCellsOpenedCount == (grid.getCellsCount() - minesCount);
  }

  void endWithWin() {
    isGameOver = true;
    onWin.call();
  }

  void endWithLoss() {
    grid.revealMines = true;
    isGameOver = true;
    onLose.call();
  }

  void restart() {
    usedFlagsCount = 0;
    saveCellsOpenedCount = 0;
    isFirstCellOpened = false;
    isGameOver = false;
    grid = Grid.generate(
      rowsCount: grid.rowsCount,
      columnsCount: grid.columnsCount,
    );
    previousActions.clear();
    nextActions.clear();
    update();
    onRestart.call();
  }

  void start() {
    onStart.call();
  }

  void update() {
    onUpdate.call();
  }
}
