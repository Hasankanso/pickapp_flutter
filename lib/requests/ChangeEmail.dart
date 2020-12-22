import 'package:pickapp/classes/App.dart';
import 'package:pickapp/requests/Request.dart';

class ChangeEmail extends Request<String> {
  String _email;

  ChangeEmail(this._email) {
    httpPath = "/UserBusiness/ChangeEmail";
  }

  @override
  String buildObject(json) {
    print(json["email"].toString());
    return json["email"].toString();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{'email': _email, 'id': App.user.id};
  }

  @override
  String isValid() {
    return null;
  }
}
