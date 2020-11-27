import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class ReserveSeat extends Request<Ride> {
  Ride _ride;
  User _user;
  int _seats, _luggages;

  ReserveSeat(this._ride, this._user, this._seats, this._luggages) {
    httpPath = "/ReserveBusiness/ReserveSeat";
  }

  @override
  buildObject(json) {
    return Ride.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'ride': {'id': _ride.id},
      'user': {'id': _user.id},
      'seats': _seats,
      'luggages': _luggages
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(_user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (Validation.isNullOrEmpty(_ride.id)) {
      return "Ride id is null";
    }
    if (_seats < 0) {
      return "Please select seats";
    }
    if (_seats > _ride.availableSeats) {
      return "There is " + _ride.availableSeats.toString() + " available seats";
    }
    if (_luggages < 0) {
      return "Please select luggage";
    }
    if (_luggages > _ride.availableLuggages) {
      return "There is " +
          _ride.availableLuggages.toString() +
          " available luggage";
    }
    return null;
  }
}
