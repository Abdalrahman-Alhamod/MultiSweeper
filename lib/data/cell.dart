import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:minesweeper/data/cell_content.dart';
import 'package:minesweeper/data/cell_status.dart';
import 'package:minesweeper/data/position.dart';
part 'cell.g.dart';

@HiveType(typeId: 1)
class Cell extends HiveObject {
  @HiveField(0)
  int _adjacentMinesCount;
  @HiveField(1)
  CellStatus _status;
  @HiveField(2)
  final Position _position;
  @HiveField(3)
  CellContent _content;
  @HiveField(4)
  final List<Cell> _chordedCells;
  @HiveField(5)
  int _actionId;

  Cell(this._adjacentMinesCount, this._content, this._position, this._status,
      this._chordedCells, this._actionId);

  Cell.fromPosition({required Position position})
      : _position = position,
        _adjacentMinesCount = 0,
        _content = CellContent.empty,
        _status = CellStatus.closed,
        _chordedCells = [],
        _actionId = -1;

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

  List<Cell> get chordedCells => _chordedCells;

  bool get isProcessed => _actionId != -1;

  int get actionId {
    // assert(_actionId != -1, "The current cell is not processed yet");
    return _actionId;
  }

  set actionId(int actionId) {
    assert(actionId >= 0, "Action id connot be negative");
    _actionId = actionId;
  }

  void addChordedCell(Cell cell) {
    _chordedCells.add(cell);
  }

  set adjacentMinesCount(int adjacentMinesCount) {
    assert(adjacentMinesCount >= 0, "Adjacent mines count cannot be negative");
    if (adjacentMinesCount == 0) {
      _adjacentMinesCount = 0;
      _content = CellContent.empty;
    } else {
      _adjacentMinesCount = adjacentMinesCount;
      _content = CellContent.number;
    }
  }

  void plantMine() => _content = CellContent.mine;

  void removeMine() => _content = CellContent.empty;

  void close() => _status = CellStatus.closed;

  void open() => _status = CellStatus.opened;

  void flag() => _status = CellStatus.flagged;

  void incrementAdjacentMinesCount() {
    assert(_content != CellContent.mine, "Cannot increment mined cell");
    if (isEmpty) {
      _content = CellContent.number;
    }
    _adjacentMinesCount++;
  }

  void decrementAdjacentMinesCount() {
    assert(_content != CellContent.mine, "Cannot decrement mined cell");
    if (isEmpty) {
      debugPrint("#### Decrement Empty Cell");
      return;
    }
    _adjacentMinesCount--;
    if (adjacentMinesCount == 0) {
      _content = CellContent.empty;
    }
  }

  Position get position => _position;
}
