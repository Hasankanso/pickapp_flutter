import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/Request.dart';

class CancelRide extends Request<bool> {
  Ride _ride;
  String _reason;

  CancelRide(this._ride, this._reason) {
    httpPath = "/RideBusiness/CancelRide";
  }

  @override
  bool buildObject(json) {
    bool x = json["deleted"];
    //todo we are comparing boolean with string?
    return x == "true";
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{'id': _ride.id, 'reason': _reason};
  }
}
