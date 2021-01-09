// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CountryInformations.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryInformationsAdapter extends TypeAdapter<CountryInformations> {
  @override
  final int typeId = 1;

  @override
  CountryInformations read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryInformations()
      .._id = fields[0] as String
      .._unit = fields[1] as String
      .._name = fields[2] as String
      .._countryComponent = fields[3] as String
      .._code = fields[4] as String
      .._digits = fields[5] as int
      .._updated = fields[6] as DateTime
      .._minPrice = fields[7] as double
      .._maxPrice = fields[8] as double
      .._drivingAge = fields[9] as int
      .._priceStep = fields[10] as double;
  }

  @override
  void write(BinaryWriter writer, CountryInformations obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._unit)
      ..writeByte(2)
      ..write(obj._name)
      ..writeByte(3)
      ..write(obj._countryComponent)
      ..writeByte(4)
      ..write(obj._code)
      ..writeByte(5)
      ..write(obj._digits)
      ..writeByte(6)
      ..write(obj._updated)
      ..writeByte(7)
      ..write(obj._minPrice)
      ..writeByte(8)
      ..write(obj._maxPrice)
      ..writeByte(9)
      ..write(obj._drivingAge)
      ..writeByte(10)
      ..write(obj._priceStep);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryInformationsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
