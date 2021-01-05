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
    return null;
  }
}
