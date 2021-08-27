import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/Request.dart';

class UpdateNotificationToken extends Request<String> {
  User _user;
  String _token;
  UpdateNotificationToken(this._user, this._token) {
    httpPath = "/UserBusiness/UpdateNotificationToken";
  }

  @override
  String buildObject(json) {
    return json["userStatus"];
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{'token': _token};
  }

  @override
  String isValid() {
    return null;
  }
}
