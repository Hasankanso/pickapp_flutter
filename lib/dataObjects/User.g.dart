// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 9;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User()
      .._id = fields[0] as String
      .._phone = fields[1] as String
      .._email = fields[2] as String
      .._verificationCode = fields[3] as String
      .._userStatus = fields[4] as String
      .._person = fields[5] as Person
      .._driver = fields[6] as Driver
      ..password = fields[7] as String
      ..sessionToken = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._phone)
      ..writeByte(2)
      ..write(obj._email)
      ..writeByte(3)
      ..write(obj._verificationCode)
      ..writeByte(4)
      ..write(obj._userStatus)
      ..writeByte(5)
      ..write(obj._person)
      ..writeByte(6)
      ..write(obj._driver)
      ..writeByte(7)
      ..write(obj.password)
      ..writeByte(8)
      ..write(obj.sessionToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
