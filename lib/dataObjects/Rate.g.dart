// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Rate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RateAdapter extends TypeAdapter<Rate> {
  @override
  final int typeId = 6;

  @override
  Rate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Rate()
      .._grade = fields[0] as double
      .._comment = fields[1] as String
      .._reason = fields[2] as int
      .._rater = fields[3] as Person
      .._target = fields[4] as Person
      .._ride = fields[5] as Ride
      .._creationDate = fields[6] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Rate obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj._grade)
      ..writeByte(1)
      ..write(obj._comment)
      ..writeByte(2)
      ..write(obj._reason)
      ..writeByte(3)
      ..write(obj._rater)
      ..writeByte(4)
      ..write(obj._target)
      ..writeByte(5)
      ..write(obj._ride)
      ..writeByte(6)
      ..write(obj._creationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
