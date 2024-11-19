import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/data/grid.dart';

import '../../data/cell.dart';
import '../../data/position.dart';

part 'grid_state.dart';

class GridCubit extends Cubit<GridState> {
  GridCubit() : super(GridInitial());

  late Grid grid;
  int minesCount = 0;
  int usedFlagsCount = 0;
  int saveCellsOpenedCount = 0;
  bool isFirstCellOpened = false;
  bool isGameOver = false;

  void init({
    required int rowsCount,
    required int columnsCount,
    required int minesCount,
  }) {
    grid = Grid(rowsCount: rowsCount, columnsCount: columnsCount);
    this.minesCount = minesCount;
    emit(GridUpdate(grid, grid.revealMines, isGameOver));
  }

  void restart() {
    usedFlagsCount = 0;
    saveCellsOpenedCount = 0;
    isFirstCellOpened = false;
    isGameOver = false;
    grid = Grid(
      rowsCount: grid.rowsCount,
      columnsCount: grid.columnsCount,
    );
    emit(GridUpdate(grid, grid.revealMines, isGameOver));
    emit(GameRestart());
  }

  void _openCell(int x, int y) {
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.open();
      if (currentCell.isMined) {
        grid.revealMines = true;
        isGameOver = true;
        emit(GameOver(win: false));
      } else {
        saveCellsOpenedCount++;
        if (!isFirstCellOpened) {
          isFirstCellOpened = true;
          _plantMines(x, y);
          emit(GameStart());
        }
        if (_checkWin()) {
          isGameOver = true;
          emit(GameOver(win: true));
          return;
        }
        if (currentCell.isEmpty) {
          _openCell(x + 1, y);
          _openCell(x - 1, y);
          _openCell(x, y + 1);
          _openCell(x, y - 1);
          _openCell(x + 1, y + 1);
          _openCell(x - 1, y - 1);
          _openCell(x + 1, y - 1);
          _openCell(x - 1, y + 1);
        }
      }
    }
  }

  void openCell({required Position position}) {
    _openCell(position.x, position.y);
    emit(
      GridUpdate(grid, grid.revealMines, isGameOver),
    );
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
    emit(
      GridUpdate(grid, grid.revealMines, isGameOver),
    );
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
    emit(
      GridUpdate(grid, grid.revealMines, isGameOver),
    );
  }
}
