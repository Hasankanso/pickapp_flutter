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
    var userJ = _user.toJson();
    userJ["id"] = _user.id;
    return <String, dynamic>{'user': userJ, 'idToken': _user.idToken};
  }

  @override
  String isValid() {
    return null;
  }
}
