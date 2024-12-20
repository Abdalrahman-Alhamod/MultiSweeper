import 'dart:io' as dart_io;
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import '../data/cell.dart';

import '../data/grid.dart';

class GameConsole {
  int minesCount;
  int usedFlagsCount;
  int saveCellsOpenedCount;
  bool isFirstCellOpened;
  Grid grid;

  GameConsole({
    required int rowsCount,
    required int columnsCount,
    required this.minesCount,
  })  : isFirstCellOpened = false,
        usedFlagsCount = minesCount,
        saveCellsOpenedCount = 0,
        grid = Grid.generate(rowsCount: rowsCount, columnsCount: columnsCount);

  void run() {
    while (true) {
      debugPrint(toString());
      debugPrint("\n1- open\n2- flag\n3- chord\nCommand :");
      int? command = int.parse(stdin.readLineSync()!);
      debugPrint("X = ");
      int? x = int.parse(stdin.readLineSync()!);
      debugPrint("Y = ");
      int? y = int.parse(stdin.readLineSync()!);
      switch (command) {
        case 1:
          {
            openCell(x, y);
          }
        case 2:
          {
            flagCell(x, y);
          }
        case 3:
          {
            chordCell(x, y);
          }
      }
    }
  }

  void plantMines() {
    int plantedMines = minesCount;
    while (plantedMines > 0) {
      Random random = Random();
      int randomX = random.nextInt(grid.columnsCount);
      int randomY = random.nextInt(grid.rowsCount);
      if (!grid.getCell(randomX, randomY).isMined) {
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

  bool checkWin() {
    return saveCellsOpenedCount == (grid.getCellsCount() - minesCount);
  }

  void openCell(int x, int y) {
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.open();
      if (currentCell.isMined) {
        endGame(win: false);
      } else {
        saveCellsOpenedCount++;
        if (!isFirstCellOpened) {
          isFirstCellOpened = true;
          plantMines();
        }
        if (checkWin()) {
          endGame(win: true);
        }
        if (currentCell.isEmpty) {
          openCell(x + 1, y);
          openCell(x - 1, y);
          openCell(x, y + 1);
          openCell(x, y - 1);
          openCell(x + 1, y + 1);
          openCell(x - 1, y - 1);
          openCell(x + 1, y - 1);
          openCell(x - 1, y + 1);
        }
      }
    }
  }

  void flagCell(int x, int y) {
    if (!grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.flag();
      usedFlagsCount--;
    } else if (currentCell.isFlagged) {
      currentCell.close();
      usedFlagsCount++;
    }
  }

  void chordCell(int x, int y) {
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
            if (cell.isFlagged && !cell.isMined) {
              endGame(win: false);
            }
            if (cell.isClosed) {
              cell.open();
            }
          },
        );
      }
    }
  }

  void endGame({required bool win}) {
    if (win) {
      debugPrint("Congratulation! You have won");
    } else {
      debugPrint('Game Over');
      grid.revealMines = true;
    }
    debugPrint(grid.toString());
    dart_io.exit(0);
  }

  @override
  String toString() {
    return "Flags = $usedFlagsCount\n$grid";
  }
}
