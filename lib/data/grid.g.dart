// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GridAdapter extends TypeAdapter<Grid> {
  @override
  final int typeId = 0;

  @override
  Grid read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grid(
      (fields[0] as List).map((dynamic e) => (e as List).cast<Cell>()).toList(),
      fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Grid obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._cells)
      ..writeByte(1)
      ..write(obj.revealMines);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GridAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
