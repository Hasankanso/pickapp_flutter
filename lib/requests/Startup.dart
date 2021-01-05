import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class Startup extends Request<String> {
  User _user;
  Startup(this._user) {
    httpPath = "/UserBusiness/Startup";
  }

  @override
  String buildObject(json) {
    return json["userStatus"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'id': _user.id,
      'verificationCode': _user.verificationCode
    };
  }

  @override
  String isValid() {
    return null;
  }
}
