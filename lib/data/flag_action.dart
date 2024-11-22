import 'package:minesweeper/data/game.dart';
import 'package:minesweeper/data/grid_action.dart';

import 'cell.dart';

class FlagAction extends GridAction {
  FlagAction({
    required super.position,
  });

  @override
  void redo({required Game game}) {
    _flagCell(game);
  }

  @override
  void run({required Game game}) {
    _flagCell(game);
  }

  @override
  void undo({required Game game}) {
    _flagCell(game);
  }

  void _flagCell(Game game) {
    int x = position.x;
    int y = position.y;
    if (!game.grid.isInsideGrid(x, y)) {
      return;
    }
    Cell currentCell = game.grid.getCell(x, y);
    if (currentCell.isClosed) {
      currentCell.flag();
      game.usedFlagsCount++;
    } else if (currentCell.isFlagged) {
      currentCell.close();
      game.usedFlagsCount--;
    }
  }
}
