import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';

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

  @override
  String isValid() {
   // return Ride.validate(_ride);
    return null;
  }
}
