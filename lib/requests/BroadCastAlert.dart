import 'package:just_miles/classes/App.dart';
import 'package:just_miles/dataObjects/Alert.dart';
import 'package:just_miles/requests/Request.dart';

class BroadCastAlert extends Request<String> {
  Alert _alert;

  BroadCastAlert(this._alert) {
    httpPath = "/AlertBusiness/AddAlert";
  }

  @override
  buildObject(json) {
    return json["message"];
  }

  @override
  Map<String, dynamic> getJson() {
    var alertJ = _alert.toJson();
    alertJ["user"] = App.user.id;
    return alertJ;
  }
}
