import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';

class CancelRide extends Request<bool> {
  Ride _ride;
  String _reason;

  CancelRide(this._ride, this._reason) {
    httpPath = "/RideBusiness/CancelRide";
  }

  @override
  bool buildObject(json) {
    return json["deleted"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{'user': App.user.id, 'id': _ride.id};
  }

  @override
  String isValid() {
    if (_ride.leavingDate.compareTo(DateTime.now()) < 0)
      return "Ride has started";

    if (Validation.isNullOrEmpty(_ride.id)) {
      return "Ride object Id is null";
    }

    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if ((_ride.passengers.length != 0 &&
        _ride.leavingDate.difference(DateTime.now()).inHours < 48)) {
      //todo need to notify the passengers, give a reason and the users can rate him
      if (Validation.isNullOrEmpty(_reason)) {
        return "You should state a good reason!";
      } else if (_reason.length < 15)
        return "The reason should be at least 15 characters";
    }
    return null;
  }
}
