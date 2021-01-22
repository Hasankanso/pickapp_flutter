import 'package:pickapp/dataObjects/MainNotification.dart';
import 'package:pickapp/dataObjects/Ride.dart';

class UpcomingRidesNotification extends MainNotification {
  Ride ride;

  UpcomingRidesNotification.fromMainNotification(
      {MainNotification notification}) {
    super.id = notification.id;
    super.description = notification.description;
    super.title = notification.title;
    super.action = notification.action;
    super.scheduleDate = notification.scheduleDate;
    super.objectId = notification.objectId;
    this.ride = ride;
  }

  setRideFromList(List<Ride> rides) {
    for (final ride in rides) {
      if (ride.id == this.objectId) {
        this.ride = ride;
        return;
      }
    }
  }
}
