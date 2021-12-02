import 'package:flutter/widgets.dart';
import 'package:just_miles/dataObjects/Alert.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class BroadcastAlertNotificationHandler extends NotificationHandler {
  Alert alert;

  BroadcastAlertNotificationHandler(MainNotification notification)
      : super(notification) {
    if (!(notification.object is Alert)) {
      notification.object = Alert.fromJson(notification.object);
    }
    this.alert = notification.object;
  }

  @override
  Future<void> cache() async {}

  @override
  Future<void> updateApp() async {}

  @override
  Future<void> display(BuildContext context) {
    if (alert == null) return null;
  }
}
