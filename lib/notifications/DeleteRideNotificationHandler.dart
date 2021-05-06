import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class DeleteRideNotificationHandler extends NotificationHandler {
  String rideId, reason;

  DeleteRideNotificationHandler(MainNotification notification) : super(notification) {
    this.rideId = (notification.object as List)[0] as String;
    this.reason = (notification.object as List)[1] as String;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    Ride r = App.getRideFromObjectId(rideId); //this is searching in App.person.upcomingsRide,
    // probably will not work in cache
    //r.passengers
    user.person.upcomingRides.remove(Ride(id: rideId));
    await Cache.setUser(user);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = true;
  }

  @override
  void display(BuildContext context) {
    // TODO: implement display
  }
}
