import 'package:minesweeper/data/grid_action_type.dart';
import 'package:minesweeper/data/position.dart';

class GridAction {
  static int _actionsId = 0;
  final int _id;
  final GridActionType actionType;
  final Position position;

  GridAction({required this.actionType, required this.position})
      : _id = GridAction._actionsId++;

  int get id => _id;
}
