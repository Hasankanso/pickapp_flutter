import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/LocalNotificationManager.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class CancelRideNotificationHandler extends NotificationHandler {
  String rideId, reason;

  CancelRideNotificationHandler(MainNotification notification)
      : super(notification) {
    List<Object> list = notification.object as List;
    this.rideId = list[0] as String;
    if (list.length > 1) this.reason = list[1] as String;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    int index = user.person.upcomingRides.indexOf(new Ride(id: rideId));
    if (index < 0) return null;

    //if there is reason =>there is rate=> status should be canceled, else delete reservation completely
    if (reason == null) {
      user.person.upcomingRides.removeAt(index);
    } else {
      user.person.upcomingRides[index].status = "CANCELED";
      user.person.upcomingRides[index].reason = this.reason;
    }

    await LocalNotificationManager.cancelLocalNotification(
        "RIDE_REMINDER" + rideId);

    await Cache.setUser(user);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
    App.user = await Cache.getUser();
  }

  @override
  void display(BuildContext context) {}
}
