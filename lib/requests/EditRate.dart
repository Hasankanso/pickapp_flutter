import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/requests/Request.dart';

class EditRate extends Request<Rate> {
  Rate _rate;

  EditRate(this._rate) {
    httpPath = "";
  }

  @override
  Rate buildObject(json) {
    // TODO: implement buildObject
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> getJson() {
    return _rate.toJson();
  }

  @override
  String isValid() {
    if (_rate.grade < 0 || _rate.grade > 5) {
      return "Invalid _rate";
    }
    if (_rate.grade < 3 && Validation.isNullOrEmpty(_rate.comment)) {
      return "Please comment the reason of low _rate";
    }
    if (_rate.creationDate.compareTo(DateTime.now().add(Duration(days: -1))) < 0) {
      return "You can't edit _rate after one day of its publishing";
    }
    if (Validation.isNullOrEmpty(_rate.rater.id)) {
      return "Invalid reviewer object id";
    }
    if (Validation.isNullOrEmpty(_rate.target.id)) {
      return "Invalid target object id";
    }
    if (Validation.isNullOrEmpty(_rate.ride.id)) {
      return "Invalid ride object id";
    }
    return null;
  }
}
