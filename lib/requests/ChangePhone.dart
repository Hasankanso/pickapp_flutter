import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class ChangePhone extends Request<User> {
  User _user;

  ChangePhone(this._user) {
    httpPath = "/UserBusiness/ChangePhone";
  }

  @override
  User buildObject(json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'user': _user.toJson(),
      'idToken': _user.idToken,
    };
  }

  @override
  String isValid() {
    return null;
  }
}
