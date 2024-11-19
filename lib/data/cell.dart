import 'package:minesweeper/data/cell_content.dart';
import 'package:minesweeper/data/cell_status.dart';
import 'package:minesweeper/data/position.dart';

class Cell {
  int _adjacentMinesCount;
  CellStatus _status;
  final Position _position;
  CellContent _content;

  Cell({required Position position})
      : _position = position,
        _adjacentMinesCount = 0,
        _content = CellContent.empty,
        _status = CellStatus.closed;

  @override
  String toString() {
    return _adjacentMinesCount.toString();
  }

  bool get isMined => _content == CellContent.mine;

  bool get isEmpty => _content == CellContent.empty;

  bool get isClosed => _status == CellStatus.closed;

  bool get isOpened => _status == CellStatus.opened;

  bool get isFlagged => _status == CellStatus.flagged;

  int get adjacentMinesCount => _adjacentMinesCount;

  void plantMine() => _content = CellContent.mine;

  void close() => _status = CellStatus.closed;

  void open() => _status = CellStatus.opened;

  void flag() => _status = CellStatus.flagged;

  void incrementAdjacentMinesCount() {
    assert(_content != CellContent.mine, "Cannot increment mined cell");
    if (_content == CellContent.empty) {
      _content = CellContent.number;
    }
    _adjacentMinesCount++;
  }

  Position get position => _position;
}
