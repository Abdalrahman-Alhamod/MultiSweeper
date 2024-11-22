// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CellStatusAdapter extends TypeAdapter<CellStatus> {
  @override
  final int typeId = 2;

  @override
  CellStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CellStatus.closed;
      case 1:
        return CellStatus.opened;
      case 2:
        return CellStatus.flagged;
      default:
        return CellStatus.closed;
    }
  }

  @override
  void write(BinaryWriter writer, CellStatus obj) {
    switch (obj) {
      case CellStatus.closed:
        writer.writeByte(0);
        break;
      case CellStatus.opened:
        writer.writeByte(1);
        break;
      case CellStatus.flagged:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CellStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
