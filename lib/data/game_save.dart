import 'package:hive_flutter/hive_flutter.dart';
import 'package:minesweeper/data/game.dart';
part 'game_save.g.dart';

@HiveType(typeId: 6)
class GameSave {
  @HiveField(0)
  final List<Game> games;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String id;

  GameSave({
    required this.games,
    required this.date,
    required this.name,
    required this.id,
  });
}
