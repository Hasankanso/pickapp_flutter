import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/Request.dart';

class EditRideRequest extends Request<Ride> {
  Ride _ride;

  EditRideRequest(this._ride) {
    httpPath = "/RideBusiness/EditRide";
  }

  @override
  buildObject(json) {
    return Ride.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var ride = _ride.toJson();
    ride["id"] = _ride.id;
    return ride;
  }
}
