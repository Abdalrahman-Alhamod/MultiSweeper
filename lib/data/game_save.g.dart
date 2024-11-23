// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_save.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameSaveAdapter extends TypeAdapter<GameSave> {
  @override
  final int typeId = 6;

  @override
  GameSave read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameSave(
      game: fields[0] as Game,
      date: fields[1] as DateTime,
      name: fields[2] as String,
      id: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GameSave obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.game)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameSaveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
