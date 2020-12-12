// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Person.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 5;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person()
      .._id = fields[0] as String
      .._firstName = fields[1] as String
      .._lastName = fields[2] as String
      .._bio = fields[3] as String
      .._profilePictureUrl = fields[4] as String
      .._birthday = fields[5] as DateTime
      .._gender = fields[6] as bool
      .._rateAverage = fields[7] as double
      .._acomplishedRides = fields[8] as int
      .._canceledRides = fields[9] as int
      .._rateCount = fields[10] as int
      .._chattiness = fields[11] as int
      .._upcomingRides = (fields[12] as List)?.cast<Ride>()
      .._rates = (fields[13] as List)?.cast<Rate>()
      .._updated = fields[14] as DateTime
      .._countryInformations = fields[15] as CountryInformations;
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._firstName)
      ..writeByte(2)
      ..write(obj._lastName)
      ..writeByte(3)
      ..write(obj._bio)
      ..writeByte(4)
      ..write(obj._profilePictureUrl)
      ..writeByte(5)
      ..write(obj._birthday)
      ..writeByte(6)
      ..write(obj._gender)
      ..writeByte(7)
      ..write(obj._rateAverage)
      ..writeByte(8)
      ..write(obj._acomplishedRides)
      ..writeByte(9)
      ..write(obj._canceledRides)
      ..writeByte(10)
      ..write(obj._rateCount)
      ..writeByte(11)
      ..write(obj._chattiness)
      ..writeByte(12)
      ..write(obj._upcomingRides)
      ..writeByte(13)
      ..write(obj._rates)
      ..writeByte(14)
      ..write(obj._updated)
      ..writeByte(15)
      ..write(obj._countryInformations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
