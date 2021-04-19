import 'dart:convert';

import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler {
  Reservation reservation;
  Map<String, dynamic> rawData;

  ReserveSeatsNotificationHandler(MainNotification notification) : super(notification) {
    if (!(notification.object is Ride)) {
      notification.object = Reservation.fromJson(notification.object);
    }
    this.reservation = notification.object;
  }

  ReserveSeatsNotificationHandler.from(this.rawData) : super.empty();

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();

    //find the ride in upcomingRides
    int rideIndex = user.person.upcomingRides.indexOf(new Ride(id: reservation.rideId));
    Ride reservedRide = user.person.upcomingRides[rideIndex];

    //add the new reservation to it
    reservedRide.passengers = new List<Reservation>.from(reservedRide.passengers);
    reservedRide.passengers.add(reservation);

    //update seats and luggage accordingly
    reservedRide.availableSeats -= reservation.seats;
    reservedRide.availableLuggages -= reservation.luggages;

    //save changes.
    await Cache.setUser(user);
  }

  @override
  void display() {
    var objectData = rawData['object'];
    Map<String, dynamic> jsonData = jsonDecode(objectData);

    String rideId = jsonData['rideId'];
    print("ride id" + rideId);

    Ride ride = App.getRideFromObjectId(rideId);
    assert(ride != null);

    App.navKey.currentState.pushNamed("/UpcomingRideDetails", arguments: [
      ride,
      Lang.getString(App.navKey.currentState.context, "Edit_Ride"),
      (ride) {
        return App.navKey.currentState.pushNamed("/EditRide", arguments: ride);
      }
    ]);
  }
}
