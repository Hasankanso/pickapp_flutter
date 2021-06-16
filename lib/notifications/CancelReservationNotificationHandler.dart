import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/notifications/RatePassengersHandler.dart';

class CancelReservationNotificationHandler extends NotificationHandler {
  String rideId, reason, passengerId;

  CancelReservationNotificationHandler(MainNotification notification)
      : super(notification) {
    List<Object> list = notification.object as List;
    this.rideId = list[0] as String;
    this.passengerId = list[1] as String;
    if (list.length > 2) this.reason = list[2] as String;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();

    int index = user.person.upcomingRides.indexOf(new Ride(id: rideId));

    if (index < 0) return null;

    Ride reservedRide = user.person.upcomingRides[index];

    if (reservedRide.passengers == null) return;

    int passIndex =
        reservedRide.passengers.indexOf(new Reservation(id: passengerId));

    if (passIndex < 0) return null;

    //fix available seats and luggage
    user.person.upcomingRides[index].availableSeats +=
        user.person.upcomingRides[index].passengers[passIndex].seats;
    user.person.upcomingRides[index].availableLuggages +=
        user.person.upcomingRides[index].passengers[passIndex].luggages;

    //if there is reason =>there is rate=> status should be canceled, else delete reservation completely
    if (reason == null)
      user.person.upcomingRides[index].passengers.removeAt(passIndex);
    else {
      user.person.upcomingRides[index].passengers[passIndex].status =
          "CANCELED";
      user.person.upcomingRides[index].passengers[passIndex].reason =
          this.reason;
    }

    await Cache.setUser(user);

    await RatePassengersHandler.updateLocalNotification(reservedRide);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
    App.user = await Cache.getUser();
  }

  @override
  Future<void> display(BuildContext context) async {
    Ride ride = await App.person.getUpcomingRideFromId(rideId);
    if (ride == null) return;

    Navigator.of(context).pushNamed("/UpcomingRideDetails", arguments: [
      ride,
      Lang.getString(context, "Edit_Ride"),
      (ride) {
        return Navigator.of(context).pushNamed("/EditRide", arguments: ride);
      }
    ]);
  }
}
