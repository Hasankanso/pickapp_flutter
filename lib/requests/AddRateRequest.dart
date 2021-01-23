import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class AddRateRequest extends Request<Rate> {
  Rate _rate;

  AddRateRequest(this._rate) {
    httpPath = "/RateBusiness/AddRate";
  }

  @override
  Rate buildObject(json) {
    return Rate.fromJson(json);
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
