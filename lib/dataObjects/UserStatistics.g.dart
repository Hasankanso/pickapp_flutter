// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserStatistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatisticsAdapter extends TypeAdapter<UserStatistics> {
  @override
  final int typeId = 13;

  @override
  UserStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatistics(
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserStatistics obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.ones)
      ..writeByte(2)
      ..write(obj.twos)
      ..writeByte(3)
      ..write(obj.threes)
      ..writeByte(4)
      ..write(obj.fours)
      ..writeByte(5)
      ..write(obj.fives);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
