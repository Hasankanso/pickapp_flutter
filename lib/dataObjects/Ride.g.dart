// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ride.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RideAdapter extends TypeAdapter<Ride> {
  @override
  final int typeId = 7;

  @override
  Ride read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ride(
      id: fields[0] as String,
      mapUrl: fields[22] as String,
      from: fields[3] as MainLocation,
      to: fields[4] as MainLocation,
      leavingDate: fields[5] as DateTime,
      musicAllowed: fields[6] as bool,
      availableSeats: fields[12] as int,
      maxSeats: fields[13] as int,
      maxLuggage: fields[14] as int,
      availableLuggage: fields[15] as int,
      reservations: (fields[19] as List)?.cast<Reservation>(),
      user: fields[18] as User,
      car: fields[20] as Car,
      updated: fields[21] as DateTime,
      status: fields[23] as String,
      reason: fields[24] as String,
    )
      .._comment = fields[1] as String
      .._acAllowed = fields[7] as bool
      .._smokingAllowed = fields[8] as bool
      .._petsAllowed = fields[9] as bool
      .._kidSeat = fields[10] as bool
      .._reserved = fields[11] as bool
      .._stopTime = fields[16] as int
      .._price = fields[17] as int;
  }

  @override
  void write(BinaryWriter writer, Ride obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj._comment)
      ..writeByte(3)
      ..write(obj.from)
      ..writeByte(4)
      ..write(obj.to)
      ..writeByte(5)
      ..write(obj.leavingDate)
      ..writeByte(6)
      ..write(obj.musicAllowed)
      ..writeByte(7)
      ..write(obj._acAllowed)
      ..writeByte(8)
      ..write(obj._smokingAllowed)
      ..writeByte(9)
      ..write(obj._petsAllowed)
      ..writeByte(10)
      ..write(obj._kidSeat)
      ..writeByte(11)
      ..write(obj._reserved)
      ..writeByte(12)
      ..write(obj.availableSeats)
      ..writeByte(13)
      ..write(obj.maxSeats)
      ..writeByte(14)
      ..write(obj.maxLuggage)
      ..writeByte(15)
      ..write(obj.availableLuggage)
      ..writeByte(16)
      ..write(obj._stopTime)
      ..writeByte(17)
      ..write(obj._price)
      ..writeByte(18)
      ..write(obj.user)
      ..writeByte(19)
      ..write(obj.reservations)
      ..writeByte(20)
      ..write(obj.car)
      ..writeByte(21)
      ..write(obj.updated)
      ..writeByte(22)
      ..write(obj.mapUrl)
      ..writeByte(23)
      ..write(obj.status)
      ..writeByte(24)
      ..write(obj.reason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RideAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
