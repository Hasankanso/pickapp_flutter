// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SearchInfo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchInfoAdapter extends TypeAdapter<SearchInfo> {
  @override
  final int typeId = 8;

  @override
  SearchInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchInfo()
      .._from = fields[0] as MainLocation
      .._to = fields[1] as MainLocation
      .._minDate = fields[2] as DateTime
      .._maxDate = fields[3] as DateTime
      .._passengersNumber = fields[4] as int
      .._luggagesNumber = fields[5] as int
      .._user = fields[6] as User
      .._rides = (fields[7] as List)?.cast<Ride>();
  }

  @override
  void write(BinaryWriter writer, SearchInfo obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._from)
      ..writeByte(1)
      ..write(obj._to)
      ..writeByte(2)
      ..write(obj._minDate)
      ..writeByte(3)
      ..write(obj._maxDate)
      ..writeByte(4)
      ..write(obj._passengersNumber)
      ..writeByte(5)
      ..write(obj._luggagesNumber)
      ..writeByte(6)
      ..write(obj._user)
      ..writeByte(7)
      ..write(obj._rides);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
