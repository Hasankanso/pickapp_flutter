import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';

class CancelReservedSeats extends Request<Ride> {
  Ride _ride;
  String _reason;

  CancelReservedSeats(this._ride, this._reason) {
    httpPath = "/RideBusiness/CancelReserved";
  }

  @override
  Ride buildObject(json) {
    return Ride.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'ride': {'id': _ride.id},
      'user': {'id': App.user.id}
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (Validation.isNullOrEmpty(_ride.id)) {
      return "Invalid id of ride";
    }
    if (_ride.leavingDate.difference(DateTime.now()).inHours < 48) {
      //todo need to notify the driver, give a reason and the driver can rate the passenger
      if (Validation.isNullOrEmpty(_reason)) {
        return "You should state a good reason!";
      } else if (_reason.length < 15)
        return "The reason should be at least 15 characters";
    }
    return null;
  }
}
