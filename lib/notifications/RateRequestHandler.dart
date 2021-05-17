import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class RateRequestHandler extends NotificationHandler {
  String rideId;
  static const String action = "RATE_REQUEST";

  RateRequestHandler(MainNotification notification) : super(notification) {
    rideId = notification.objectId;
  }

  @override
  Future<void> cache() async {}

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
}
