import 'open_action.dart';
import 'position.dart';
import 'package:uuid/uuid.dart';

import 'chord_action.dart';
import 'flag_action.dart';
import 'game.dart';

var uuid = const Uuid();

abstract class GridAction {
  final String _id;
  final Position position;

  GridAction({
    required this.position,
    String? id,
  }) : _id = id ?? uuid.v4();

  String get id => _id;

  void run({required Game game});
  void undo({required Game game});
  void redo({required Game game});

  Map<String, dynamic> toJson() => {
        'id': _id,
        'position': position.toJson(),
      };

  factory GridAction.fromJson(Map<String, dynamic> json) {
    String runtimeType = json['type'];
    switch (runtimeType) {
      case "OpenAction":
        {
          return OpenAction(
            position: Position.fromJson(json['position']),
            id: json['id'],
          );
        }
      case "FlagAction":
        {
          return FlagAction(
            position: Position.fromJson(json['position']),
            id: json['id'],
          );
        }
      case "ChordAction":
        {
          return ChordAction(
            position: Position.fromJson(json['position']),
            id: json['id'],
          );
        }
      default:
        {
          throw Exception("Unknow runtime type");
        }
    }
  }
}
