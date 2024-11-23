import 'package:hive/hive.dart';

part 'position.g.dart';

@HiveType(typeId: 4)
class Position extends HiveObject {
  @HiveField(0)
  final int x;
  @HiveField(1)
  final int y;

  Position({required this.x, required this.y});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position &&
          runtimeType == other.runtimeType &&
          x == other.x &&
          y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
