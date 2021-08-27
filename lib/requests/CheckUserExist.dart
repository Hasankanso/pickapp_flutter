import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/Request.dart';

class CheckUserExist extends Request<bool> {
  User _user;

  CheckUserExist(this._user) {
    httpPath = "/UserBusiness/CheckUserExist";
  }

  @override
  bool buildObject(json) {
    return json["exist"] == "true";
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'phone': _user.phone,
    };
  }

  @override
  String isValid() {
    return null;
  }
}
