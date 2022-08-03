// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ScheduledNotification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledNotificationAdapter extends TypeAdapter<ScheduledNotification> {
  @override
  final int typeId = 14;

  @override
  ScheduledNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledNotification(
      fields[1] as MainNotification,
    ).._id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, ScheduledNotification obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj.notification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
