import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';
import 'package:just_miles/notifications/RatePassengersHandler.dart';

class CancelReservationNotificationHandler extends NotificationHandler {
  String rideId, reason, passengerId;

  //the driver canceled the ride, and here we're handling for the passenger.
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

    if (reservedRide.reservations == null) return;

    int passIndex =
        reservedRide.reservations.indexOf(new Reservation(id: passengerId));

    if (passIndex < 0) return null;

    //fix available seats and luggage
    reservedRide.availableSeats += reservedRide.reservations[passIndex].seats;
    reservedRide.availableLuggages +=
        reservedRide.reservations[passIndex].luggage;

    //if there is reason =>there is rate=> status should be canceled, else delete reservation completely
    if (reason == null) {
      //if last reservation remove rating notification
      if (reservedRide.reservations.length == 1) {
        await RatePassengersHandler.removeLocalNotification(reservedRide);
      }
      reservedRide.reservations.removeAt(passIndex);
    } else {
      reservedRide.reservations[passIndex].status = "CANCELED";
      reservedRide.reservations[passIndex].reason = this.reason;
    }

    await Cache.setUser(user);
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
