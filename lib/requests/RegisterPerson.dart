import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class RegisterPerson extends Request<User> {
  User _newUser;

  RegisterPerson(this._newUser) {
    httpPath = "/UserBusiness/Register";
  }

  @override
  User buildObject(json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'user': _newUser.toJson(),
      'idToken': _newUser.idToken
    };
  }

  @override
  String isValid() {
    return null;
  }
}
