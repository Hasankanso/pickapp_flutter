import 'package:pickapp/classes/App.dart';
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
    bool x = json["deleted"];
    return x == "true";
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'user': App.user.id,
      'id': _ride.id,
      'reason': _reason
    };
  }

  @override
  String isValid() {
    return null;
  }
}
