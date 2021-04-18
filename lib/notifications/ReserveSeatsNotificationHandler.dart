import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/notifications/NotificationsHandler.dart';

class ReserveSeatsNotificationHandler extends NotificationHandler {
  Passenger reservation;
  Map<String, dynamic> rawData;

  ReserveSeatsNotificationHandler(MainNotification notification) : super(notification) {
    if (!(notification.object is Ride)) {
      notification.object = Passenger.fromJson(notification.object);
    }
    this.reservation = notification.object;
  }

  ReserveSeatsNotificationHandler.from(this.rawData) : super.empty();

  @override
  Future<void> cache() async {
    User user = await Cache.getUser();
    List<Ride> upcomingRides = user.person.upcomingRides;
    Ride reservedRide = new Ride(id: reservation.rideId);

    reservedRide = upcomingRides.removeAt(upcomingRides.indexOf(reservedRide)); //remove ride with
    reservedRide.passengers.add(reservation);
    // same id
    user.person.upcomingRides.add(reservedRide); //add new ride with slightly different information.
    await Cache.setUser(user);
  }

  @override
  void display() {
    print(rawData);
    print(rawData['rideId']);
    Ride ride = App.getRideFromObjectId(rawData['rideId']);
    print(ride);
    assert(ride != null);
    App.navKey.currentState.pushNamed("/RideDetails", arguments: ride);
  }
}
