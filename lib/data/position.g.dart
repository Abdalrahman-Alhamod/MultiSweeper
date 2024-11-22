// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionAdapter extends TypeAdapter<Position> {
  @override
  final int typeId = 3;

  @override
  Position read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Position(
      x: fields[0] as int,
      y: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Position obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
