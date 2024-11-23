
import 'package:minesweeper/data/position.dart';
import 'package:uuid/uuid.dart';
import 'game.dart';

var uuid = const Uuid();

class GridAction {
  final String _id;
  final Position position;

  GridAction({
    required this.position,
  }) : _id = uuid.v4();

  String get id => _id;

  void run({required Game game}) {}
  void undo({required Game game}) {}
  void redo({required Game game}) {}
}
