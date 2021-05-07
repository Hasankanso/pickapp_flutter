import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class UpdateToken extends Request<String> {
  User _user;
  String _token;
  UpdateToken(this._user, this._token) {
    httpPath = "/UserBusiness/UpdateToken";
  }

  @override
  String buildObject(json) {
    return json["userStatus"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'id': _user.id,
      'verificationCode': _user.verificationCode,
      'token': _token
    };
  }

  @override
  String isValid() {
    return null;
  }
}
