import 'package:just_miles/classes/App.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/requests/Request.dart';

class RateDriverRequest extends Request<bool> {
  Rate _rate;
  bool isDriver = false;
  RateDriverRequest(this._rate) {
    httpPath = "/RateBusiness/RateDriver";
  }

  @override
  bool buildObject(json) {
    return json["sent"];
  }

  @override
  Map<String, dynamic> getJson() {
    return {
      "fullName": App.person.fullName,
      "rate": _rate.toJson(),
    };
  }
}
