import 'package:hive/hive.dart';
import 'package:minesweeper/data/cell.dart';
import 'package:minesweeper/data/position.dart';
part 'grid.g.dart';

@HiveType(typeId: 0)
class Grid extends HiveObject {
  @HiveField(0)
  final List<List<Cell>> _cells;

  @HiveField(1)
  bool revealMines;

  Grid(this._cells, this.revealMines);

  Grid.generate({
    required int rowsCount,
    required int columnsCount,
  })  : revealMines = false,
        _cells = List.generate(
          rowsCount,
          (y) => List.generate(
            columnsCount,
            (x) => Cell.fromPosition(
              position: Position(
                x: x,
                y: y,
              ),
            ),
          ),
        );

  Cell getCell(int x, int y) {
    return _cells[y][x];
  }

  int get rowsCount => _cells.length;

  int get columnsCount => _cells.first.length;

  // helper
  void runOnAdjacentCells(int x, int y, Function(Cell cell) function) {
    List<int> dx = [-1, 0, 1, -1, 1, -1, 0, 1];
    List<int> dy = [-1, -1, -1, 0, 0, 1, 1, 1];
    for (int i = 0; i < dx.length; i++) {
      int newX = x + dx[i];
      int newY = y + dy[i];
      if (isInsideGrid(newX, newY)) {
        function.call(getCell(newX, newY));
      }
    }
  }

  // helper
  void runOnCells(Function(Cell) function) {
    for (List<Cell> row in _cells) {
      for (Cell cell in row) {
        function.call(cell);
      }
    }
  }

  // helper
  bool isInsideGrid(int x, int y) {
    return x >= 0 && x < columnsCount && y >= 0 && y < rowsCount;
  }

  // helper
  int getAdjacentFlaggedCellsCount(int x, int y) {
    int flaggedCellsCount = 0;
    runOnAdjacentCells(
      x,
      y,
      (cell) {
        if (cell.isFlagged) {
          flaggedCellsCount++;
        }
      },
    );
    return flaggedCellsCount;
  }

  // helper
  int getAdjacentMinedCellsCount(int x, int y) {
    int minedCellsCount = 0;
    runOnAdjacentCells(
      x,
      y,
      (cell) {
        if (cell.isMined) {
          minedCellsCount++;
        }
      },
    );
    return minedCellsCount;
  }

  // helper
  bool _isLastInRowCell(Cell cell) {
    return cell.position.x == columnsCount - 1;
  }

  String _reveledBoard() {
    String board = "";
    runOnCells(
      (cell) {
        if (cell.isMined) {
          if (cell.isClosed) {
            board += "\$ "; // normal mine
          } else if (cell.isFlagged) {
            board += "P ";
          } else if (cell.isOpened) {
            board += "* "; // blown mine
          }
        } else {
          if (cell.isClosed) {
            board += "# ";
          } else if (cell.isFlagged) {
            board += "X "; // false flag place
          } else if (cell.isOpened) {
            board += "${cell.adjacentMinesCount} ";
          }
        }
        if (_isLastInRowCell(cell)) {
          board += '\n';
        }
      },
    );
    return board;
  }

  String _normalBoard() {
    String board = "";
    runOnCells(
      (cell) {
        if (cell.isClosed) {
          board += "# ";
        } else if (cell.isFlagged) {
          board += "P ";
        } else if (cell.isOpened) {
          board += "${cell.adjacentMinesCount} ";
        }
        if (_isLastInRowCell(cell)) {
          board += '\n';
        }
      },
    );
    return board;
  }

  int getCellsCount() {
    return columnsCount * rowsCount;
  }

  @override
  String toString() {
    if (revealMines) return _reveledBoard();

    return _normalBoard();
  }
}
