import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class LoginRequest extends Request<User> {
  User _user;
  LoginRequest(this._user) {
    httpPath = "/UserBusiness/Login";
  }

  @override
  User buildObject(json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'phone': _user.phone,
      'verificationCode': _user.verificationCode
    };
  }

  @override
  String isValid() {
    if (Validation.isNullOrEmpty(_user.verificationCode) ||
        _user.verificationCode.length != 5) {
      return "Invalid code";
    }
    return null;
  }
}
