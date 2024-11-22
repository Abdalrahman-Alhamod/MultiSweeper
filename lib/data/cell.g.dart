// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CellAdapter extends TypeAdapter<Cell> {
  @override
  final int typeId = 1;

  @override
  Cell read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cell(
      fields[0] as int,
      fields[3] as CellContent,
      fields[2] as Position,
      fields[1] as CellStatus,
      fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Cell obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._adjacentMinesCount)
      ..writeByte(1)
      ..write(obj._status)
      ..writeByte(2)
      ..write(obj._position)
      ..writeByte(3)
      ..write(obj._content)
      ..writeByte(4)
      ..write(obj._actionId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
