import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class RateDriverHandler extends NotificationHandler {
  String rideId;
  static const String action = "RATE_DRIVER";
  static const String prefix = "rate_driver.";

  RateDriverHandler(MainNotification notification) : super(notification) {
    if (!(notification.object is String)) {
      this.rideId = notification.object as String;
    }
    this.rideId = notification.object;
  }

  @override
  Future<void> cache() async {}

  @override
  Future<void> updateApp() async {}

  @override
  Future<void> display(BuildContext context) async {
    Ride ride =
        await App.person.getUpcomingRideFromId(rideId, searchHistory: true);
    if (ride == null) {
      //in case user removed the ride. but later clicked the notification
      return;
    }
    if (ride != null) {
      Navigator.of(context).pushNamed("/RateDriver",
          arguments: [ride, ride.person, null, null, notification]);
    }
  }

  static Future<void> updateLocalNotification(Ride ride) async {
    int notificationReq =
        await Cache.getScheduledNotificationId(prefix + ride.id);

    if (notificationReq == null) {
      return; //there's nothing to check.
    }

    if (ride.reservations.isEmpty) {
      LocalNotificationManager.cancelLocalNotification(prefix + ride.id);
    }
  }
}
