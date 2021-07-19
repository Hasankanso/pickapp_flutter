import 'package:pickapp/requests/Request.dart';

class Logout extends Request<bool> {
  Logout() {
    httpPath = "/UserBusiness/Logout";
  }

  @override
  bool buildObject(json) {
    bool x = json["loggedOut"];
    return x == "true";
  }

  @override
  Map<String, dynamic> getJson() {
    return null;
  }

  @override
  String isValid() {
    return null;
  }
}
