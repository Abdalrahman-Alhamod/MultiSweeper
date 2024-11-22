import 'package:minesweeper/data/game.dart';
import 'package:minesweeper/data/grid_action.dart';

import 'cell.dart';

class ChordAction extends GridAction {
  ChordAction({
    required super.position,
  });

  @override
  void redo({required Game game}) {
    _chordCell(game);
  }

  @override
  void run({required Game game}) {
    _chordCell(game);
  }

  @override
  void undo({required Game game}) {
    _unChordCell(game);
  }

  void _unChordCell(Game game) {
    int x = position.x;
    int y = position.y;
    if (!game.grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = game.grid.getCell(x, y);
    if (currentCell.isOpened) {
      int flaggedCellsCount = game.grid.getAdjacentFlaggedCellsCount(x, y);
      if (flaggedCellsCount == currentCell.adjacentMinesCount) {
        game.grid.runOnAdjacentCells(
          x,
          y,
          (cell) {
            if (cell.isOpened && id == cell.actionId) {
              cell.close();
              game.saveCellsOpenedCount--;
            }
          },
        );
      }
    }
  }

  void _chordCell(Game game) {
    int x = position.x;
    int y = position.y;
    if (!game.grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = game.grid.getCell(x, y);
    if (currentCell.isOpened) {
      int flaggedCellsCount = game.grid.getAdjacentFlaggedCellsCount(x, y);
      if (flaggedCellsCount == currentCell.adjacentMinesCount) {
        game.grid.runOnAdjacentCells(
          x,
          y,
          (cell) {
            if (cell.isClosed) {
              cell.open();
              cell.actionId = id;
              if (cell.isMined) {
                game.endWithLoss();
              } else {
                game.saveCellsOpenedCount++;
                if (game.checkWin()) {
                  game.endWithWin();
                }
              }
            }
          },
        );
      }
    }
  }
}
