import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class CancelReservationNotificationHandler extends NotificationHandler {
  Ride ride;

  CancelReservationNotificationHandler(MainNotification notification)
      : super(notification) {
    //cast
    //save rate in notification.object and in this.rate
    Ride ride = Ride.fromJson(notification.object);
    notification.object = ride;
    this.ride = ride;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    user.person.upcomingRides.remove(ride);
    await Cache.setUser(user);
  }

  @override
  void display() {
    // TODO: implement display
  }
}
