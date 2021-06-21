import 'package:flutter/material.dart';
import 'package:pickapp/notifications/MainNotification.dart';

abstract class NotificationHandler {
  MainNotification notification;

  NotificationHandler(this.notification);

  NotificationHandler.empty();

  Future<void> cache();
  Future<void> updateApp();
  Future<void> display(BuildContext context);
}
