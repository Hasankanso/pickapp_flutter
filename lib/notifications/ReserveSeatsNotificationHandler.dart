import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';
import 'package:just_miles/notifications/RatePassengersHandler.dart';
import 'package:just_miles/repository/user/user_repository.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler {
  Reservation reservation;

  ReserveSeatsNotificationHandler(MainNotification notification)
      : super(notification) {
    if (!(notification.object is Reservation)) {
      if (notification.object != null)
        notification.object = Reservation.fromJson(notification.object);
    }
    this.reservation = notification.object;
  }

  @override
  Future<void> cache() async {
    if (reservation == null) return;

    User user = await UserRepository().get();

    //find the ride in upcomingRides
    int rideIndex =
        user.person.upcomingRides.indexOf(new Ride(id: reservation.rideId));
    if (rideIndex < 0)
      return; //ride not found maybe the user removed it, this should be handled

    Ride reservedRide = user.person.upcomingRides[rideIndex];
    //add the new reservation to it
    if (reservedRide.reservations == null ||
        reservedRide.reservations.isEmpty) {
      reservedRide.reservations = <Reservation>[];
    } else {
      reservedRide.reservations =
          new List<Reservation>.from(reservedRide.reservations);
    }
    reservedRide.reservations.add(reservation);

    //update seats and luggage accordingly
    reservedRide.availableSeats -= reservation.seats;
    reservedRide.availableLuggages -= reservation.luggage;
    //save changes.
    await UserRepository().updateUser(user);

    //add rateNotification.
    await RatePassengersHandler.createLocalNotification(reservedRide);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
  }

  @override
  Future<void> display(BuildContext context) async {
    Ride ride = await App.person.getUpcomingRideFromId(reservation.rideId);
    if (ride == null) {
      //in case user removed the ride. but later clicked the notification
      return;
    }

    Navigator.of(context).pushNamed("/UpcomingRideDetails", arguments: [
      ride,
      Lang.getString(context, "Edit_Ride"),
      (ride) {
        return Navigator.of(context).pushNamed("/EditRide", arguments: ride);
      }
    ]);
  }
}
