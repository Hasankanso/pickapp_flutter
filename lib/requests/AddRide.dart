import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/Request.dart';

class AddRide extends Request<Ride> {
  Ride _ride;

  AddRide(this._ride) {
    httpPath = "/RideBusiness/AddRide";
  }

  @override
  Ride buildObject(json) {
    return Ride.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return _ride.toJson();
  }
}
