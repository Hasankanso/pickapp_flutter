import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/BaseDataObject.dart';
import 'package:just_miles/notifications/MainNotification.dart';

part 'ScheduledNotification.g.dart';

@HiveType(typeId: 14)
class ScheduledNotification extends BaseDataObject {
  @HiveField(0)
  int _id;
  @HiveField(1)
  MainNotification notification;

  ScheduledNotification(this.notification) {
    _id = notification.notificationId;
    this.notification = notification;
  }

  ScheduledNotification.fromJson(Map<String, dynamic> json) {
    MainNotification notification = MainNotification.fromJson(json);
    _id = notification.notificationId;
    this.notification = notification;
  }
  String get id => _id.toString();

  set id(value) {
    _id = int.parse(value);
  }

  Map<String, dynamic> toJson() => notification.toJson();
  static String get boxName => "scheduledNotifications";
}
