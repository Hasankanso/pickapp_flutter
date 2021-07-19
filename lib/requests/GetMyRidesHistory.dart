import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class GetMyRidesHistory extends Request<List<Ride>> {
  User _user;

  GetMyRidesHistory(this._user) {
    httpPath = "/RideBusiness/GetMyRidesHistory";
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
    return null;
  }
}
