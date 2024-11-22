
import 'package:hive/hive.dart';

part 'cell_status.g.dart';

@HiveType(typeId: 2)
enum CellStatus {
  @HiveField(0)
  closed,
  @HiveField(1)
  opened,
  @HiveField(2)
  flagged
}
