import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Alert.dart';
import 'package:pickapp/requests/Request.dart';

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

  @override
  String isValid() {
    //todo need detailed checking
    /*  if (_alert.minDate.compareTo(DateTime.now()) < 0) {
      return "Minimum date range can't be empty!";
    }
    if (_alert.minDate.compareTo(App.maxAlertDate) > 0) {
      return "The max period of alert is six months";
    }

    if (_alert.maxDate.compareTo(DateTime.now()) < 0) {
      return "Invalid maximum date range";
    }
    if (_alert.maxDate.compareTo(App.maxAlertDate) > 0) {
      return "The max period of alert is six months";
    }
    if (_alert.maxDate.compareTo(_alert.minDate) < 0) {
      return "The maximum date range couldn't be less tham the minimum.";
    }
    if (_alert.price == 0) {
      return "Set your alert price";
    }*/
    return null;
  }
}
