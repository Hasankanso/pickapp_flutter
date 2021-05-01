import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class DeleteRideNotificationHandler extends NotificationHandler {
  String rideId, reason;

  DeleteRideNotificationHandler(MainNotification notification)
      : super(notification) {
    print(notification.object.runtimeType);
    print(notification.object);
    this.rideId = (notification.object as List)[0] as String;
    this.reason = (notification.object as List)[1] as String;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    user.person.upcomingRides.remove(Ride(id: rideId));
    await Cache.setUser(user);
  }

  @override
  void display(BuildContext context) {
    // TODO: implement display
  }
}
