import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class AddRateRequest extends Request<bool> {
  List<Rate> _rates;

  AddRateRequest(this._rates) {
    httpPath = "/RateBusiness/AddRate";
  }

  @override
  bool buildObject(json) {
    return json["sent"] == "true";
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{"rates": List<dynamic>.from(_rates.map((x) => x.toJson()))};
  }

  @override
  String isValid() {
    return null;
  }
}
