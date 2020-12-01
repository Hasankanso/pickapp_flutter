import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class CheckUserExist extends Request<bool> {
  User _user;

  CheckUserExist(this._user) {
    httpPath = "/UserBusiness/CheckUserExist";
  }

  @override
  bool buildObject(json) {
    return json["exist"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'phone': _user.phone,
    };
  }

  @override
  String isValid() {
    if (!Validation.validPhoneNumber(_user.phone)) {
      return "Invalid phone number";
    }
    return null;
  }
}
