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
    return Ride()
      .._id = fields[0] as String
      .._comment = fields[1] as String
      .._mapUrl = fields[2] as String
      .._from = fields[3] as MainLocation
      .._to = fields[4] as MainLocation
      .._leavingDate = fields[5] as DateTime
      .._musicAllowed = fields[6] as bool
      .._acAllowed = fields[7] as bool
      .._smokingAllowed = fields[8] as bool
      .._petsAllowed = fields[9] as bool
      .._kidSeat = fields[10] as bool
      .._reserved = fields[11] as bool
      .._availableSeats = fields[12] as int
      .._maxSeats = fields[13] as int
      .._maxLuggages = fields[14] as int
      .._reservedSeats = fields[15] as int
      .._availableLuggages = fields[16] as int
      .._reservedLuggages = fields[17] as int
      .._stopTime = fields[18] as int
      .._price = fields[19] as int
      .._user = fields[20] as User
      .._passengers = (fields[21] as List)?.cast<Passenger>()
      .._car = fields[22] as Car
      .._updated = fields[23] as DateTime;
  }

  @override
  void write(BinaryWriter writer, Ride obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._comment)
      ..writeByte(2)
      ..write(obj._mapUrl)
      ..writeByte(3)
      ..write(obj._from)
      ..writeByte(4)
      ..write(obj._to)
      ..writeByte(5)
      ..write(obj._leavingDate)
      ..writeByte(6)
      ..write(obj._musicAllowed)
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
      ..write(obj._availableSeats)
      ..writeByte(13)
      ..write(obj._maxSeats)
      ..writeByte(14)
      ..write(obj._maxLuggages)
      ..writeByte(15)
      ..write(obj._reservedSeats)
      ..writeByte(16)
      ..write(obj._availableLuggages)
      ..writeByte(17)
      ..write(obj._reservedLuggages)
      ..writeByte(18)
      ..write(obj._stopTime)
      ..writeByte(19)
      ..write(obj._price)
      ..writeByte(20)
      ..write(obj._user)
      ..writeByte(21)
      ..write(obj._passengers)
      ..writeByte(22)
      ..write(obj._car)
      ..writeByte(23)
      ..write(obj._updated);
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
