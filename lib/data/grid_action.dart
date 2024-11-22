import 'package:minesweeper/data/position.dart';

import 'game.dart';

abstract class GridAction {
  static int _actionsId = 0;
  final int _id;
  final Position position;

  GridAction({
    required this.position,
  }) : _id = GridAction._actionsId++;

  int get id => _id;

  void run({required Game game});
  void undo({required Game game});
  void redo({required Game game});
}
