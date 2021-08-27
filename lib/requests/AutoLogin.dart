import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/Request.dart';

class AutoLogin extends Request<String> {
  String userId, password;

  AutoLogin(this.userId, this.password) {
    httpPath = "/UserBusiness/AutoLogin";
  }

  fromUser(User user) {
    httpPath = "/UserBusiness/AutoLogin";

    userId = user.id;
    password = user.password;
  }

  @override
  String buildObject(json) {
    return json["token"];
  }

  @override
  Map<String, dynamic> getJson() {
    Map<String, dynamic> json = new Map();

    json["id"] = userId;
    json["password"] = password;

    return json;
  }

  @override
  String isValid() {
    if (Validation.isNullOrEmpty(userId) || Validation.isNullOrEmpty(password)) {
      return "Authentication_Error";
    }
    return null;
  }
}
