import 'game.dart';

class GameSave {
  final List<Game> games;
  final DateTime date;
  final String name;
  final String id;

  GameSave({
    required this.games,
    required this.date,
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toJson() => {
        'games': games.map((game) => game.toJson()).toList(),
        'date': date.toIso8601String(),
        'name': name,
        'id': id,
      };

  static GameSave fromJson(Map<String, dynamic> json) => GameSave(
        games: (json['games'] as List<dynamic>)
            .map((gameJson) => Game.fromJson(gameJson))
            .toList(),
        date: DateTime.parse(json['date']),
        name: json['name'],
        id: json['id'],
      );
}
