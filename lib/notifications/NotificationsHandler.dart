import 'package:flutter/cupertino.dart';
import 'package:pickapp/notifications/MainNotification.dart';


abstract class NotificationHandler {

  final MainNotification notification;

  NotificationHandler(this.notification);

  void cache();
  void updateApp();
  void display(NavigatorState state);

}