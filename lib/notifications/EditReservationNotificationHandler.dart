import 'package:flutter/widgets.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/NotificationsHandler.dart';

class EditReservationNotificationHandler extends NotificationHandler {
  Reservation reservation;

  EditReservationNotificationHandler(MainNotification notification) : super(notification) {
    if (!(notification.object is Reservation)) {
      notification.object = Reservation.fromJson(notification.object);
    }
    this.reservation = notification.object;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();

    //find the ride in upcomingRides
    int rideIndex = user.person.upcomingRides.indexOf(new Ride(id: reservation.rideId));

    if (rideIndex < 0) return;

    Ride reservedRide = user.person.upcomingRides[rideIndex];

    //add the new reservation to it

    reservedRide.reservations = new List<Reservation>.from(reservedRide.reservations);

    int oldReservIndex = reservedRide.reservations.indexOf(reservation);

    if (oldReservIndex < 0) return;
    Reservation oldReservation = reservedRide.reservations[oldReservIndex];

    reservedRide.reservations.remove(reservation);
    reservedRide.reservations.add(reservation);

    //update seats and luggage accordingly
    reservedRide.availableSeats =
        (reservedRide.availableSeats + oldReservation.seats) - reservation.seats;
    reservedRide.availableLuggages =
        (reservedRide.availableLuggages + oldReservation.luggage) + reservation.luggage;

    //save changes.
    await Cache.setUser(user);
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
