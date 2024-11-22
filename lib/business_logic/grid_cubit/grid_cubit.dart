import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/data/grid.dart';
import 'package:minesweeper/data/grid_action.dart';
import 'package:minesweeper/data/grid_action_type.dart';

import '../../data/cell.dart';
import '../../data/position.dart';
import '../../helpers/stack.dart';
part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit() : super(GridInitial());

  late Grid grid;
  int minesCount = 0;
  int usedFlagsCount = 0;
  int saveCellsOpenedCount = 0;
  bool isFirstCellOpened = false;
  bool isGameOver = false;
  Position? _firstOpendCellPosition;
  DStack<GridAction> previousActions = DStack();
  DStack<GridAction> nextActions = DStack();

  void init({
    required int rowsCount,
    required int columnsCount,
    required int minesCount,
  }) {
    grid = Grid.generate(rowsCount: rowsCount, columnsCount: columnsCount);
    this.minesCount = minesCount;
    _firstOpendCellPosition = null;
    previousActions.clear();
    nextActions.clear();
    emit(GridUpdate(grid, grid.revealMines, isGameOver));
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
    _firstOpendCellPosition = null;
    previousActions.clear();
    nextActions.clear();
    emit(GridUpdate(grid, grid.revealMines, isGameOver));
    emit(GameRestart());
  }

  void execute({required GridAction action}) {
    switch (action.actionType) {
      case GridActionType.open:
        {
          openCell(position: action.position, actionId: action.id);
          break;
        }
      case GridActionType.flag:
        {
          flagCell(position: action.position);
          break;
        }
      case GridActionType.chord:
        {
          chordCell(position: action.position);
          break;
        }
    }
    nextActions.clear();
    previousActions.push(action);
    emit(
      GridUpdate(grid, grid.revealMines, isGameOver),
    );
  }

  void undo() {
    if (previousActions.isEmpty || isGameOver) {
      return;
    }
    GridAction lastAction = previousActions.pop();
    nextActions.push(lastAction);
    debugPrint("Action Id ${lastAction.id}");
    switch (lastAction.actionType) {
      case GridActionType.open:
        {
          _unOpenCell(
              lastAction.position.x, lastAction.position.y, lastAction.id);
          break;
        }
      case GridActionType.flag:
        {
          flagCell(position: lastAction.position);
          break;
        }
      case GridActionType.chord:
        {
          unChordCell(position: lastAction.position);
          break;
        }
    }
    emit(
      GridUpdate(grid, grid.revealMines, isGameOver),
    );
  }

  void redo() {
    if (nextActions.isEmpty || isGameOver) {
      return;
    }
    GridAction nextAction = nextActions.pop();
    previousActions.push(nextAction);
    switch (nextAction.actionType) {
      case GridActionType.open:
        {
          openCell(position: nextAction.position, actionId: nextAction.id);
          break;
        }
      case GridActionType.flag:
        {
          flagCell(position: nextAction.position);
          break;
        }
      case GridActionType.chord:
        {
          chordCell(position: nextAction.position);
          break;
        }
    }
    emit(
      GridUpdate(grid, grid.revealMines, isGameOver),
    );
  }

  void _unOpenCell(int x, int y, int actionId) {
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    debugPrint(
        "Is undo processed ${currentCell.isOpened && currentCell.actionId == actionId}");
    if (currentCell.isOpened && currentCell.actionId == actionId) {
      currentCell.close();
      saveCellsOpenedCount--;
      // Position currentCellPosition = Position(x: x, y: y);
      // if (isFirstCellOpened &&
      //     _firstOpendCellPosition != null &&
      //     _firstOpendCellPosition == currentCellPosition) {
      //   isFirstCellOpened = false;
      //   _firstOpendCellPosition = null;
      //   _removeMines();
      // }
      if (currentCell.isEmpty) {
        _unOpenCell(x + 1, y, actionId);
        _unOpenCell(x - 1, y, actionId);
        _unOpenCell(x, y + 1, actionId);
        _unOpenCell(x, y - 1, actionId);
        _unOpenCell(x + 1, y + 1, actionId);
        _unOpenCell(x - 1, y - 1, actionId);
        _unOpenCell(x + 1, y - 1, actionId);
        _unOpenCell(x - 1, y + 1, actionId);
      }
    }
  }

  void _openCell(int x, int y, int actionId) {
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.open();
      currentCell.actionId = actionId;
      if (currentCell.isMined) {
        grid.revealMines = true;
        isGameOver = true;
        emit(GameOver(win: false));
      } else {
        saveCellsOpenedCount++;
        if (!isFirstCellOpened) {
          isFirstCellOpened = true;
          _firstOpendCellPosition = Position(x: x, y: y);
          _plantMines(x, y);
          emit(GameStart());
        }
        if (_checkWin()) {
          isGameOver = true;
          emit(GameOver(win: true));
          return;
        }
        if (currentCell.isEmpty) {
          _openCell(x + 1, y, actionId);
          _openCell(x - 1, y, actionId);
          _openCell(x, y + 1, actionId);
          _openCell(x, y - 1, actionId);
          _openCell(x + 1, y + 1, actionId);
          _openCell(x - 1, y - 1, actionId);
          _openCell(x + 1, y - 1, actionId);
          _openCell(x - 1, y + 1, actionId);
        }
      }
    }
  }

  void openCell({required Position position, required int actionId}) {
    _openCell(position.x, position.y, actionId);
  }

  void _removeMines() {
    grid.runOnCells((cell) {
      if (cell.isMined) {
        cell.removeMine();
        cell.adjacentMinesCount =
            grid.getAdjacentMinedCellsCount(cell.position.x, cell.position.y);
        grid.runOnAdjacentCells(
          cell.position.x,
          cell.position.y,
          (cell) {
            if (!cell.isMined) {
              cell.decrementAdjacentMinesCount();
            }
          },
        );
      }
    });
  }

  void _plantMines(int x, int y) {
    int plantedMines = minesCount;
    while (plantedMines > 0) {
      Random random = Random();
      int randomX = random.nextInt(grid.columnsCount);
      int randomY = random.nextInt(grid.rowsCount);
      if (!grid.getCell(randomX, randomY).isMined &&
          (randomX != x || randomY != y)) {
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

  bool _checkWin() {
    return saveCellsOpenedCount == (grid.getCellsCount() - minesCount);
  }

  void flagCell({required Position position}) {
    int x = position.x;
    int y = position.y;
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.flag();
      usedFlagsCount++;
    } else if (currentCell.isFlagged) {
      currentCell.close();
      usedFlagsCount--;
    }
    emit(
      FlagsCountUpdate(
        flagsCount: minesCount - usedFlagsCount,
      ),
    );
  }

  void unChordCell({required Position position}) {
    int x = position.x;
    int y = position.y;
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isOpened) {
      int flaggedCellsCount = grid.getAdjacentFlaggedCellsCount(x, y);
      if (flaggedCellsCount == currentCell.adjacentMinesCount) {
        for (Cell cell in currentCell.chordedCells) {
          if (cell.isOpened) {
            cell.close();
            saveCellsOpenedCount--;
          }
        }
      }
    }
  }

  void chordCell({required Position position}) {
    int x = position.x;
    int y = position.y;
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isOpened) {
      int flaggedCellsCount = grid.getAdjacentFlaggedCellsCount(x, y);
      if (flaggedCellsCount == currentCell.adjacentMinesCount) {
        grid.runOnAdjacentCells(
          x,
          y,
          (cell) {
            if (cell.isClosed) {
              cell.open();
              currentCell.addChordedCell(cell);
              if (cell.isMined) {
                grid.revealMines = true;
                isGameOver = true;
                emit(GameOver(win: false));
              } else {
                saveCellsOpenedCount++;
                if (_checkWin()) {
                  isGameOver = true;
                  emit(GameOver(win: true));
                }
              }
            }
          },
        );
      }
    }
  }
}
