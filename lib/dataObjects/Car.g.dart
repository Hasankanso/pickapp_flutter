// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Car.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 0;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      carPictureUrl: fields[4] as String,
    )
      .._id = fields[0] as String
      .._name = fields[1] as String
      .._color = fields[2] as int
      .._brand = fields[3] as String
      .._year = fields[5] as int
      .._maxLuggage = fields[6] as int
      .._maxSeats = fields[7] as int
      .._updated = fields[8] as DateTime
      .._type = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._color)
      ..writeByte(3)
      ..write(obj._brand)
      ..writeByte(4)
      ..write(obj.carPictureUrl)
      ..writeByte(5)
      ..write(obj._year)
      ..writeByte(6)
      ..write(obj._maxLuggage)
      ..writeByte(7)
      ..write(obj._maxSeats)
      ..writeByte(8)
      ..write(obj._updated)
      ..writeByte(9)
      ..write(obj._type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
