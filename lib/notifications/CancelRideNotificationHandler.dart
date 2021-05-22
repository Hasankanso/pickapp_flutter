import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class CancelRideNotificationHandler extends NotificationHandler {
  String rideId, reason;

  CancelRideNotificationHandler(MainNotification notification)
      : super(notification) {
    List<Object> list = notification.object as List;
    print("a");
    this.rideId = list[0] as String;
    print("aa");

    if (list.length > 1) this.reason = list[1] as String;
    print("888");
  }

  @override
  Future<void> cache() async {
    print(1);
    User user = await Cache.getUser();
    print(2);

    int index = user.person.upcomingRides.indexOf(new Ride(id: rideId));
    print(3);

    if (index < 0) return null;
    print(4);

    //if there is reason =>there is rate=> status should be canceled, else delete reservation completely
    if (reason == null) {
      print(5);
      user.person.upcomingRides.removeAt(index);
    } else {
      print(6);

      user.person.upcomingRides[index].status = "CANCELED";
      print(7);

      user.person.upcomingRides[index].reason = this.reason;
    }
    print(8);

    await Cache.setUser(user);
    print(9);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
    App.user = await Cache.getUser();
  }

  @override
  void display(BuildContext context) {}
}
