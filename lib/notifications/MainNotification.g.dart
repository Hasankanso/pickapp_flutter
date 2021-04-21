// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MainNotification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MainNotificationAdapter extends TypeAdapter<MainNotification> {
  @override
  final int typeId = 12;

  @override
  MainNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MainNotification(
      object: fields[9] as Object,
      sentTime: fields[10] as DateTime,
    )
      .._id = fields[0] as int
      .._objectId = fields[1] as String
      .._action = fields[2] as String
      .._title = fields[3] as String
      .._body = fields[4] as String
      .._scheduleDate = fields[5] as DateTime
      .._subtitle = fields[6] as String
      .._imagePath = fields[7] as String
      .._imageUrl = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, MainNotification obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._objectId)
      ..writeByte(2)
      ..write(obj._action)
      ..writeByte(3)
      ..write(obj._title)
      ..writeByte(4)
      ..write(obj._body)
      ..writeByte(5)
      ..write(obj._scheduleDate)
      ..writeByte(6)
      ..write(obj._subtitle)
      ..writeByte(7)
      ..write(obj._imagePath)
      ..writeByte(8)
      ..write(obj._imageUrl)
      ..writeByte(9)
      ..write(obj.object)
      ..writeByte(10)
      ..write(obj.sentTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MainNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
