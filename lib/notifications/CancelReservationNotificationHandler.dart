import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class CancelReservationNotificationHandler extends NotificationHandler {
  String rideId, reason, passengerId;

  CancelReservationNotificationHandler(MainNotification notification) : super(notification) {
    this.rideId = (notification.object as List)[0] as String;
    this.passengerId = (notification.object as List)[1] as String;
    this.reason = (notification.object as List)[2] as String;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();

    int index = user.person.upcomingRides.indexOf(new Ride(id: rideId));

    if (index < 0) return null;

    Ride r = user.person.upcomingRides[index];

    int passIndex = r.passengers.indexOf(new Reservation(id: passengerId));

    if (passIndex < 0) return null;

    user.person.upcomingRides[index].passengers.removeAt(passIndex);

    await Cache.setUser(user);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
  }

  @override
  void display(BuildContext context) {
    // TODO: implement display
  }
}
