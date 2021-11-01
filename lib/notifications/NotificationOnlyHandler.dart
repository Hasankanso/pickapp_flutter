import 'package:flutter/material.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class NotificationOnlyHandler extends NotificationHandler {
  NotificationOnlyHandler(MainNotification notification) : super(notification);

  @override
  Future<void> cache() async {}

  @override
  Future<void> updateApp() async {}

  @override
  Future<void> display(BuildContext context) async {}
}
