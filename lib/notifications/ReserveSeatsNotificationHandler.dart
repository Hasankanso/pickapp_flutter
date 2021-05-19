import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/LocalNotificationManager.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';
import 'package:pickapp/notifications/RateNotificationHandler.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler {
  Reservation reservation;

  ReserveSeatsNotificationHandler(MainNotification notification)
      : super(notification) {
    if (!(notification.object is Ride)) {
      notification.object = Reservation.fromJson(notification.object);
    }
    this.reservation = notification.object;
  }

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();

    //find the ride in upcomingRides
    int rideIndex =
        user.person.upcomingRides.indexOf(new Ride(id: reservation.rideId));

    if (rideIndex < 0)
      return; //ride not found maybe the user removed it, this should be handled

    Ride reservedRide = user.person.upcomingRides[rideIndex];

    //add the new reservation to it
    if (reservedRide.passengers == null || reservedRide.passengers.isEmpty) {
      reservedRide.passengers = <Reservation>[];
    } else {
      reservedRide.passengers =
          new List<Reservation>.from(reservedRide.passengers);
    }
    reservedRide.passengers.add(reservation);

    //update seats and luggage accordingly
    reservedRide.availableSeats -= reservation.seats;
    reservedRide.availableLuggages -= reservation.luggages;

    //save changes.
    await Cache.setUser(user);

    //add rateNotification.

    PendingNotificationRequest notificationReq =
        await LocalNotificationManager.getLocalNotification(
            reservedRide.leavingDate.microsecondsSinceEpoch);

    if (notificationReq != null) {
      return; //it's already added.
    }

    DateTime popUpDate = reservedRide.leavingDate
        .add(Duration(hours: App.person.countryInformations.rateStartHours));
    MainNotification rateNotification = new MainNotification(
        id: reservedRide.leavingDate.millisecondsSinceEpoch,
        objectId: reservedRide.id,
        title: "How Were Passengers?",
        body:
            "Review passengers from ${reservedRide.from.name} -> ${reservedRide.to.name} ride",
        scheduleDate: popUpDate,
        action: RateNotificationHandler.action);

    LocalNotificationManager.pushLocalNotification(rateNotification);
  }

  @override
  Future<void> updateApp() async {
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
  }

  @override
  void display(BuildContext context) {
    Ride ride = App.person.getUpcomingRideFromId(reservation.rideId);
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
