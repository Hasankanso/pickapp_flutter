import 'package:pickapp/notifications/MainNotification.dart';

abstract class NotificationHandler {
  MainNotification notification;

  NotificationHandler(this.notification);

  NotificationHandler.empty();

  Future<void> cache();
  void updateApp();
  void display();
}
