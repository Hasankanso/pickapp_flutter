import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';

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

    r.passengers.remove(reserve);
    r.passengers.add(reserve);
    return r;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'ride': {'id': _ride.id},
      'user': App.user.id,
      'seats': _seats,
      'luggage': _luggage
    };
  }

  @override
  String isValid() {
    return null;
  }
}
