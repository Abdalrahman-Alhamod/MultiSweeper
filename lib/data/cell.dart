import 'package:minesweeper/data/cell_content.dart';
import 'package:minesweeper/data/cell_status.dart';
import 'package:minesweeper/data/position.dart';

class Cell {
  int _adjacentMinesCount;
  CellStatus _status;
  final Position _position;
  CellContent _content;
  String _actionId;

  Cell(this._adjacentMinesCount, this._content, this._position, this._status,
      this._actionId);

  Cell.clone(Cell cell)
      : this(
          cell._adjacentMinesCount,
          cell._content,
          cell._position,
          cell._status,
          cell._actionId,
        );

  Cell.fromPosition({required Position position})
      : _position = position,
        _adjacentMinesCount = 0,
        _content = CellContent.empty,
        _status = CellStatus.closed,
        _actionId = "";

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

  bool get isProcessed => _actionId != "";

  String get actionId => _actionId;

  set actionId(String actionId) {
    assert(actionId.isNotEmpty, "Action id connot be empty");
    _actionId = actionId;
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
      return;
    }
    _adjacentMinesCount--;
    if (adjacentMinesCount == 0) {
      _content = CellContent.empty;
    }
  }

  Position get position => _position;

  Map<String, dynamic> toJson() => {
        'adjacentMinesCount': _adjacentMinesCount,
        'status': _status.toString(),
        'position': _position.toJson(),
        'content': _content.toString(),
        'actionId': _actionId,
      };

  factory Cell.fromJson(Map<String, dynamic> json) {
    return Cell(
      json['adjacentMinesCount'],
      CellContent.values.firstWhere((e) => e.toString() == json['content']),
      Position.fromJson(json['position']),
      CellStatus.values.firstWhere((e) => e.toString() == json['status']),
      json['actionId'],
    );
  }
}
