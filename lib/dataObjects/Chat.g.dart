// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatAdapter extends TypeAdapter<Chat> {
  @override
  final int typeId = 10;

  @override
  Chat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Chat()
      .._id = fields[0] as String
      .._lastMessagedate = fields[1] as DateTime
      .._messages = (fields[2] as List)?.cast<Message>()
      .._person = fields[3] as Person
      .._isNewMessage = fields[4] as bool;
  }

  @override
  void write(BinaryWriter writer, Chat obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._lastMessagedate)
      ..writeByte(2)
      ..write(obj._messages)
      ..writeByte(3)
      ..write(obj._person)
      ..writeByte(4)
      ..write(obj._isNewMessage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
