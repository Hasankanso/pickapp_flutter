import 'package:just_miles/classes/App.dart';
import 'package:just_miles/requests/Request.dart';

class ChangeEmail extends Request<String> {
  String _email;

  ChangeEmail(this._email) {
    httpPath = "/UserBusiness/ChangeEmail";
  }

  @override
  String buildObject(json) {
    return json["email"].toString();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{'email': _email, 'id': App.user.id};
  }
}
