import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';

class EditRide extends Request<Ride> {
  Ride _ride;

  EditRide(this._ride) {
    httpPath = "/RideBusiness/EditRide";
  }
  //todo edit ride should send user id

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

  @override
  String isValid() {
    return null;
  }
}
