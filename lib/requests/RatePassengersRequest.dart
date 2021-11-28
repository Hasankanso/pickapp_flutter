import 'package:just_miles/classes/App.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/requests/Request.dart';

class RatePassengersRequest extends Request<bool> {
  List<Rate> _rates;
  RatePassengersRequest(this._rates) {
    httpPath = "/RateBusiness/RatePassengers";
  }

  @override
  bool buildObject(json) {
    return json["sent"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      "fullName": App.person.fullName,
      "rates": List<dynamic>.from(_rates.map((x) => x.toJson()))
    };
  }
}
