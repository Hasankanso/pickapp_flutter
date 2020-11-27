import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class GetMyUpComingRides extends Request<List<Ride>> {
  User _user;

  GetMyUpComingRides(this._user) {
    httpPath = "/RideBusiness/GetMyUpcomingRides";
  }

  @override
  List<Ride> buildObject(json) {
    return json != null
        ? List<Ride>.from(json.map((x) => Ride.fromJson(x)))
        : null;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'user': _user.id,
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(_user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    return null;
  }
}
