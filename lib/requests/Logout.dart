import 'package:pickapp/requests/Request.dart';

class Logout extends Request<String> {
  @override
  String buildObject(json) {
    return "{}";
  }

  @override
  Map<String, dynamic> getJson() {
    return {};
  }

  @override
  String isValid() {
    return null;
  }
}
