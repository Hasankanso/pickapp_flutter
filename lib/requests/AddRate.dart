import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class AddRate extends Request<Rate> {
  Rate _rate;

  AddRate(this._rate) {
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
    String rateValidation = Rate.validate(_rate);
    if (!Validation.isNullOrEmpty(rateValidation)) {
      return rateValidation;
    }
    return null;
  }
}
