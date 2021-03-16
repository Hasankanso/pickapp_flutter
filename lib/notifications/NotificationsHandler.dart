import 'package:flutter/cupertino.dart';
import 'package:pickapp/notifications/MainNotification.dart';

abstract class NotificationHandler {
  final MainNotification notification;

  NotificationHandler(this.notification);

  Future<void> cache();
  void display(NavigatorState state);
}
