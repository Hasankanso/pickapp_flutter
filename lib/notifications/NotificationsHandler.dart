import 'package:flutter/cupertino.dart';
import 'package:pickapp/notifications/MainNotification.dart';


abstract class NotificationHandler<T> {

  final MainNotification notification;

  NotificationHandler(this.notification);

  void cache(T object);
  void updateApp(T object);
  void display(NavigatorState state, T object);

}