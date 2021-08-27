import 'package:flutter/widgets.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/requests/Request.dart';

class AddRateRequest extends Request<bool> {
  List<Rate> _rates;
  bool isDriver = false;
  AddRateRequest(this._rates, {@required this.isDriver}) {
    httpPath = "/RateBusiness/AddRate";
  }

  @override
  bool buildObject(json) {
    return json["sent"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'isDriver': isDriver,
      "rates": List<dynamic>.from(_rates.map((x) => x.toJson()))
    };
  }

  @override
  String isValid() {
    return null;
  }
}
