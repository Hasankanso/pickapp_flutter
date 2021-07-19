import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

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

  @override
  String isValid() {
    if (Validation.isNullOrEmpty(_ride.id)) {
      return "Ride id is null";
    }
    if (_seats < 0) {
      return "Please select seats";
    }
    if (_seats > _ride.availableSeats) {
      return "There is " + _ride.availableSeats.toString() + " available seats";
    }
    if (_luggage < 0) {
      return "Please select luggage";
    }
    if (_luggage > _ride.availableLuggages) {
      return "There is " +
          _ride.availableLuggages.toString() +
          " available luggage";
    }
    return null;
  }
}
