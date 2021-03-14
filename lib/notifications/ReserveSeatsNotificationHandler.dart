import 'package:flutter/widgets.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler {
  Ride ride;

  ReserveSeatsNotificationHandler(MainNotification notification)
      : super(notification) {

    Ride ride = Ride.fromJson(notification.object);
    notification.object = ride;
    this.ride = ride;
  }

  @override
  void cache() {
    // TODO: implement cache
  }

  @override
  void display(NavigatorState state) {
    // TODO: implement display
  }

  @override
  void updateApp() {
    // TODO: implement updateApp
  }
}
