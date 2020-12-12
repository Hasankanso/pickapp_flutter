// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Driver.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DriverAdapter extends TypeAdapter<Driver> {
  @override
  final int typeId = 2;

  @override
  Driver read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Driver()
      .._id = fields[0] as String
      .._regions = (fields[1] as List)?.cast<MainLocation>()
      .._cars = (fields[2] as List)?.cast<Car>()
      .._updated = fields[3] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Driver obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._regions)
      ..writeByte(2)
      ..write(obj._cars)
      ..writeByte(3)
      ..write(obj._updated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
