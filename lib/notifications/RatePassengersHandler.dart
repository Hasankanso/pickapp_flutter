import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class RatePassengersHandler extends NotificationHandler {
  String rideId;
  static const String action = "RATE_PASSENGERS";
  static const String prefix = "rate_passengers.";

  RatePassengersHandler(MainNotification notification) : super(notification) {
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
    if (ride != null &&
        ride.reservations != null &&
        ride.reservations.isNotEmpty)
      Navigator.of(context)
          .pushNamed("/RatePassengers", arguments: [ride, notification]);
  }

  static Future<void> createLocalNotification(Ride ride) async {
    int notificationReq =
        await Cache.getScheduledNotificationId(prefix + ride.id);
    if (notificationReq == null) {
      DateTime popUpDate = ride.leavingDate
          .add(Duration(hours: App.person.countryInformations.rateStartHours));
      MainNotification rateNotification = new MainNotification(
          title: "How Were Passengers?",
          body:
              "Review passengers from ${ride.from.name} -> ${ride.to.name} ride",
          object: ride.id,
          scheduleDate: popUpDate,
          action: RatePassengersHandler.action);
      await LocalNotificationManager.pushLocalNotification(
          rateNotification, prefix + ride.id);
    }
  }

  static Future<bool> removeLocalNotification(Ride ride) async {
    return await LocalNotificationManager.cancelLocalNotification(
        prefix + ride.id);
  }
}
