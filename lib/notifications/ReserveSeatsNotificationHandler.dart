import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler {
  Ride ride;

  ReserveSeatsNotificationHandler(MainNotification notification)
      : super(notification) {
    if (!(notification.object is Ride)) {
      notification.object = Ride.fromJson(notification.object);
    }
    this.ride = notification.object;
  }

  ReserveSeatsNotificationHandler.from(this.ride) : super.empty();

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    user.person.upcomingRides.remove(ride); //remove ride with same id
    user.person.upcomingRides.add(ride); //add new ride with slightly different information.
    await Cache.setUser(user);
  }

  @override
  void display() {
    assert(this.ride!=null);
    App.navKey.currentState.pushNamed("/RideView", arguments: ride);
  }

  @override
  void updateApp() {
    App.updateUpcomingRide.value = true;
  }
}
