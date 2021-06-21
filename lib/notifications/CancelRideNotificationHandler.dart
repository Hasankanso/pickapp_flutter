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
  DateTime cancellationDate;

  CancelRideNotificationHandler(MainNotification notification)
      : super(notification) {
    List<Object> list = notification.object as List;
    this.rideId = list[0] as String;
    if (list.length > 1) {
      this.reason = list[1] as String;
      this.cancellationDate =
          DateTime.fromMillisecondsSinceEpoch((list[2] as int), isUtc: true)
              .toLocal();
    }
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    int index = user.person.upcomingRides.indexOf(new Ride(id: rideId));
    if (index < 0) return null;

    user.person.upcomingRides[index].status = "CANCELED";

    await LocalNotificationManager.cancelLocalNotification(
        "ride_reminder." + rideId);

    await Cache.setUser(user);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
    App.user = await Cache.getUser();
  }

  @override
  Future<void> display(BuildContext context) async {
    Ride ride =
        await App.person.getUpcomingRideFromId(rideId, searchHistory: true);

    if (ride == null ||
        ride.status != "CANCELED" ||
        reason == null ||
        cancellationDate
                .compareTo(DateTime.now().add(App.availableDurationToRate)) >=
            0) return;

    Navigator.of(context).pushNamed("/RateDriver",
        arguments: [ride, ride.person, reason, cancellationDate, notification]);
  }
}
