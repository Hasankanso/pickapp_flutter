import 'package:just_miles/classes/App.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/Request.dart';

class EditReservation extends Request<Ride> {
  Ride _ride;
  int _seats, _luggage;

  EditReservation(this._ride, this._seats, this._luggage) {
    httpPath = "/ReserveBusiness/EditReservation";
  }

  @override
  Ride buildObject(json) {
    Reservation reserve = Reservation.fromJson(json);
    dynamic ride = json["ride"];
    Ride r = App.person.getUpcomingRideOnlyFromId(ride["objectId"]);

    r.availableSeats = ride["availableSeats"];
    r.availableLuggages = ride["availableLuggages"];

    r.reservations.remove(reserve);
    r.reservations.add(reserve);
    return r;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'fullName': App.person.fullName,
      'newReservation': {
        'ride': {'id': _ride.id},
        'user': App.user.id,
        'seats': _seats,
        'luggage': _luggage
      }
    };
  }
}
