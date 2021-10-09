import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/Request.dart';

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
}
