// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameAdapter extends TypeAdapter<Game> {
  @override
  final int typeId = 5;

  @override
  Game read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game(
      fields[0] as Grid,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      fields[4] as bool,
      fields[5] as bool,
      fields[6] as int,
      fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.grid)
      ..writeByte(1)
      ..write(obj.minesCount)
      ..writeByte(2)
      ..write(obj.usedFlagsCount)
      ..writeByte(3)
      ..write(obj.saveCellsOpenedCount)
      ..writeByte(4)
      ..write(obj.isFirstCellOpened)
      ..writeByte(5)
      ..write(obj.isGameOver)
      ..writeByte(6)
      ..write(obj.time)
      ..writeByte(7)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
