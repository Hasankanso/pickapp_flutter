// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Reservation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReservationAdapter extends TypeAdapter<Reservation> {
  @override
  final int typeId = 4;

  @override
  Reservation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reservation(
      person: fields[0] as Person,
      luggage: fields[2] as int,
      seats: fields[3] as int,
      id: fields[1] as String,
      updated: fields[4] as DateTime,
      rideId: fields[5] as String,
      status: fields[6] as String,
      reason: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reservation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.person)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.luggage)
      ..writeByte(3)
      ..write(obj.seats)
      ..writeByte(4)
      ..write(obj.updated)
      ..writeByte(5)
      ..write(obj.rideId)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.reason);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
