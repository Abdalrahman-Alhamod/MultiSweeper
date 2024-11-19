import 'package:minesweeper/data/cell.dart';
import 'package:minesweeper/data/position.dart';

class Grid {
  final List<List<Cell>> _cells;
  int rowsNumber;
  int columnsNumber;
  bool revealMines;

  Grid({
    required this.rowsNumber,
    required this.columnsNumber,
  })  : revealMines = false,
        _cells = List.generate(
          rowsNumber,
          (y) => List.generate(
            columnsNumber,
            (x) => Cell(
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

  int getRowsCount() {
    return rowsNumber;
  }

  int getColumnCount() {
    return columnsNumber;
  }

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
    return x >= 0 && x < columnsNumber && y >= 0 && y < rowsNumber;
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
  bool _isLastInRowCell(Cell cell) {
    return cell.position.x == columnsNumber - 1;
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
    return getColumnCount() * getRowsCount();
  }

  @override
  String toString() {
    if (revealMines) return _reveledBoard();

    return _normalBoard();
  }
}
