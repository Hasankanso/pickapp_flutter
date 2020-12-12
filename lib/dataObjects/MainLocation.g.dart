// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MainLocation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainLocationAdapter extends TypeAdapter<MainLocation> {
  @override
  final int typeId = 3;

  @override
  MainLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainLocation()
      .._name = fields[0] as String
      .._id = fields[1] as String
      .._placeId = fields[2] as String
      .._latitude = fields[3] as double
      .._longitude = fields[4] as double
      .._updated = fields[5] as DateTime;
  }

  @override
  void write(BinaryWriter writer, MainLocation obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._name)
      ..writeByte(1)
      ..write(obj._id)
      ..writeByte(2)
      ..write(obj._placeId)
      ..writeByte(3)
      ..write(obj._latitude)
      ..writeByte(4)
      ..write(obj._longitude)
      ..writeByte(5)
      ..write(obj._updated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
