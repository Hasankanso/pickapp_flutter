import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class AddRateRequest extends Request<bool> {
  Rate _rate;

  AddRateRequest(this._rate) {
    httpPath = "/RateBusiness/AddRate";
  }

  @override
  bool buildObject(json) {
    return json["sent"] == "true";
  }

  @override
  Map<String, dynamic> getJson() {
    return _rate.toJson();
  }

  @override
  String isValid() {
    return null;
  }
}
