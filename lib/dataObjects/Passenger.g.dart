// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Passenger.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PassengerAdapter extends TypeAdapter<Passenger> {
  @override
  final int typeId = 4;

  @override
  Passenger read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Passenger(
      rideId: fields[5] as String,
    )
      .._person = fields[0] as Person
      .._id = fields[1] as String
      .._luggages = fields[2] as int
      .._seats = fields[3] as int
      .._updated = fields[4] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Passenger obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._person)
      ..writeByte(1)
      ..write(obj._id)
      ..writeByte(2)
      ..write(obj._luggages)
      ..writeByte(3)
      ..write(obj._seats)
      ..writeByte(4)
      ..write(obj._updated)
      ..writeByte(5)
      ..write(obj.rideId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PassengerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
