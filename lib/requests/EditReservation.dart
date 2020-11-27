import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
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
    return Ride.fromJson(json);
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
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (Validation.isNullOrEmpty(_ride.id)) {
      return "Ride id is null";
    }
    if (_seats < 0) {
      return "Please select seats";
    }
    if (_seats == (_ride.availableSeats + _ride.passengers[0].seats)) {
      return "You have been already reserved " +
          (_ride.availableSeats + _ride.passengers[0].seats).toString() +
          " seats";
    }
    if (_luggage == (_ride.availableLuggages + _ride.passengers[0].luggages)) {
      return "You have been already reserved " +
          (_ride.availableLuggages + _ride.passengers[0].luggages).toString() +
          " luggage";
    }
    if (_seats > (_ride.availableSeats + _ride.passengers[0].seats)) {
      return "There is " +
          (_ride.availableSeats + _ride.passengers[0].seats).toString() +
          " available seats";
    }
    if (_luggage < 0) {
      return "Please select luggage";
    }
    if (_luggage > _ride.availableLuggages + _ride.passengers[0].luggages) {
      return "There is " +
          _ride.availableLuggages +
          _ride.passengers[0].luggages.toString() +
          " available luggage";
    }
    return null;
  }
}
