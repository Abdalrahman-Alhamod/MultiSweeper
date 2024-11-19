import 'package:minesweeper/data/cell_status.dart';
import 'package:minesweeper/data/position.dart';

class Cell {
  int _value;
  CellStatus _status;
  final Position _position;

  Cell({required Position position})
      : _position = position,
        _value = 0,
        _status = CellStatus.closed;

  @override
  String toString() {
    return _value.toString();
  }

  bool isMined() {
    return _value == -1;
  }

  void plantMine() {
    _value = -1;
  }

  bool isEmpty() {
    return _value == 0;
  }

  bool isClosed() {
    return _status == CellStatus.closed;
  }

  bool isOpened() {
    return _status == CellStatus.opened;
  }

  bool isFlagged() {
    return _status == CellStatus.flagged;
  }

  void close() {
    _status = CellStatus.closed;
  }

  void open() {
    _status = CellStatus.opened;
  }

  void flag() {
    _status = CellStatus.flagged;
  }

  int adjacentMinesCount() {
    return _value;
  }

  void incrementAdjacentMinesCount() {
    if (isMined()) {
      return;
    }
    _value++;
  }

  Position get position => _position;
}
