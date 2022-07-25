import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';
import 'package:just_miles/notifications/RateDriverHandler.dart';
import 'package:just_miles/repository/user/user_repository.dart';

class CancelRideNotificationHandler extends NotificationHandler {
  String rideId, reason;
  DateTime cancellationDate;

  CancelRideNotificationHandler(MainNotification notification)
      : super(notification) {
    List<Object> list = notification.object as List;
    this.rideId = list[0] as String;
    if (list.length > 1) {
      this.reason = list[1] as String;
      this.cancellationDate = DateTime.parse(list[2]).toLocal();
    }
  }

  @override
  Future<void> cache() async {
    User user = await UserRepository().get();
    int index = user.person.upcomingRides.indexOf(new Ride(id: rideId));
    if (index < 0) return null;
    user.person.upcomingRides[index].status = "CANCELED";

    await LocalNotificationManager.cancelLocalNotification(
        "ride_reminder." + rideId);

    await UserRepository().updateUser(user);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
    App.user = await UserRepository().get();
  }

  @override
  Future<void> display(BuildContext context) async {
    Ride ride =
        await App.person.getUpcomingRideFromId(rideId, searchHistory: true);

    if (ride == null) {
      return;
    }
    if (ride.status != "CANCELED" ||
        reason == null ||
        cancellationDate
                .compareTo(DateTime.now().add(App.availableDurationToRate)) >=
            0) {
      await RateDriverHandler.removeLocalNotification(ride);
      return;
    }

    Navigator.of(context).pushNamed("/RateDriver",
        arguments: [ride, ride.person, reason, cancellationDate, notification]);
  }
}
