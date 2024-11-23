
import 'package:hive/hive.dart';

part 'cell_content.g.dart';
@HiveType(typeId: 3)
enum CellContent {
  @HiveField(0)
  empty,
  @HiveField(1)
  number,
  @HiveField(2)
  mine
}
