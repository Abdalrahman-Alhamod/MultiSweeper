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
}
