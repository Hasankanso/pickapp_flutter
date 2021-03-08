import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class LoginRequest extends Request<User> {
  User _user;
  String _token;
  LoginRequest(this._user, this._token) {
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
      'verificationCode': _user.verificationCode,
      'token': _token,
    };
  }

  @override
  String isValid() {
    return null;
  }
}
