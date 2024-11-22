// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CellContentAdapter extends TypeAdapter<CellContent> {
  @override
  final int typeId = 4;

  @override
  CellContent read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CellContent.empty;
      case 1:
        return CellContent.number;
      case 2:
        return CellContent.mine;
      default:
        return CellContent.empty;
    }
  }

  @override
  void write(BinaryWriter writer, CellContent obj) {
    switch (obj) {
      case CellContent.empty:
        writer.writeByte(0);
        break;
      case CellContent.number:
        writer.writeByte(1);
        break;
      case CellContent.mine:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
