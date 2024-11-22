import 'package:minesweeper/data/grid_action.dart';

import 'cell.dart';
import 'game.dart';
import 'position.dart';

class OpenAction extends GridAction {
  OpenAction({
    required super.position,
  });

  @override
  void redo({required Game game}) {
    _openCell(position.x, position.y, game);
  }

  @override
  void run({required Game game}) {
    _openCell(position.x, position.y, game);
  }

  @override
  void undo({required Game game}) {
    _unOpenCell(position.x, position.y, game);
  }

  void _openCell(
    int x,
    int y,
    Game game,
  ) {
    if (!game.grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = game.grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.open();
      currentCell.actionId = id;
      if (currentCell.isMined) {
        game.endWithLoss();
      } else {
        game.saveCellsOpenedCount++;
        if (!game.isFirstCellOpened) {
          game.isFirstCellOpened = true;
          game.plantMines(exludedPosition: Position(x: x, y: y));
          game.start();
        }
        if (game.checkWin()) {
          game.endWithWin();
          return;
        }
        if (currentCell.isEmpty) {
          _openCell(x + 1, y, game);
          _openCell(x - 1, y, game);
          _openCell(x, y + 1, game);
          _openCell(x, y - 1, game);
          _openCell(x + 1, y + 1, game);
          _openCell(x - 1, y - 1, game);
          _openCell(x + 1, y - 1, game);
          _openCell(x - 1, y + 1, game);
        }
      }
    }
  }

  void _unOpenCell(
    int x,
    int y,
    Game game,
  ) {
    if (!game.grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = game.grid.getCell(x, y);
    if (currentCell.isOpened && currentCell.actionId == id) {
      currentCell.close();
      game.saveCellsOpenedCount--;
      if (currentCell.isEmpty) {
        _unOpenCell(x + 1, y, game);
        _unOpenCell(x - 1, y, game);
        _unOpenCell(x, y + 1, game);
        _unOpenCell(x, y - 1, game);
        _unOpenCell(x + 1, y + 1, game);
        _unOpenCell(x - 1, y - 1, game);
        _unOpenCell(x + 1, y - 1, game);
        _unOpenCell(x - 1, y + 1, game);
      }
    }
  }
}
