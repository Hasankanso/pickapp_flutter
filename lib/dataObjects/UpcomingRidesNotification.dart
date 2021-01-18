import 'package:pickapp/dataObjects/MainNotification.dart';
import 'package:pickapp/dataObjects/Ride.dart';

class UpcomingRidesNotification extends MainNotification {
  Ride ride;

  UpcomingRidesNotification(
      {String title,
      String description,
      int id,
      String action,
      DateTime scheduleDate,
      Ride ride}) {
    super.id = id;
    super.description = description;
    super.title = title;
    super.action = action;
    super.scheduleDate = scheduleDate;
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
