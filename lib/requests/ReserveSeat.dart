import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/Request.dart';

class ReserveSeat extends Request<Ride> {
  Ride _ride;
  User _user;
  int _seats, _luggage;

  ReserveSeat(this._ride, this._user, this._seats, this._luggage) {
    httpPath = "/ReserveBusiness/ReserveSeat";
  }

  @override
  buildObject(json) {
    var reservation = Reservation.fromJson(json);
    var ride = Ride.fromJson(json["ride"]);
    ride.reservations == null
        ? ride.reservations = [reservation]
        : ride.reservations.add(reservation);
    return ride;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'ride': {'id': _ride.id},
      'user': {'id': _user.id},
      'seats': _seats,
      'luggages': _luggage
    };
  }
}
