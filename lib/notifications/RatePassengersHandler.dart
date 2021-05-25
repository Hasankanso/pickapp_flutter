import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/LocalNotificationManager.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class RatePassengersHandler extends NotificationHandler {
  String rideId;
  static const String action = "RATE_PASSENGERS";
  static const String prefix = "rate_passengers.";

  RatePassengersHandler(MainNotification notification) : super(notification) {
    rideId = notification.objectId;
  }

  @override
  Future<void> cache() async {
    //LocalNotificationManager.cleanAfterNotificationPopped(rideId);
  }

  @override
  Future<void> updateApp() async {}

  @override
  void display(BuildContext context) {
    Ride ride = App.person.getUpcomingRideFromId(rideId);

    if (ride == null) {
      //in case user removed the ride. but later clicked the notification
      return;
    }

    Navigator.of(context).pushNamed("/RatePassengers", arguments: ride);
  }

  static Future<void> createLocalNotification(Ride ride) async {
    PendingNotificationRequest notificationReq =
        await LocalNotificationManager.getLocalNotification(prefix + ride.id);

    if (notificationReq != null) {
      return; //it's already added.
    }

    DateTime popUpDate =
        ride.leavingDate.add(Duration(hours: App.person.countryInformations.rateStartHours));
    MainNotification rateNotification = new MainNotification(
        objectId: ride.id,
        title: "How Were Passengers?",
        body: "Review passengers from ${ride.from.name} -> ${ride.to.name} ride",
        scheduleDate: popUpDate,
        action: RatePassengersHandler.action);

    LocalNotificationManager.pushLocalNotification(rateNotification, prefix + ride.id);
  }

  static Future<void> updateLocalNotification(Ride ride) async {
    PendingNotificationRequest notificationReq =
        await LocalNotificationManager.getLocalNotification(prefix + ride.id);

    if (notificationReq == null) {
      return; //there's nothing to check.
    }

    if (ride.passengers.isEmpty) {
      LocalNotificationManager.cancelLocalNotification(prefix + ride.id);
    }
  }
}
