import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/Request.dart';

class UpdateNotificationToken extends Request<String> {
  String _token;
  UpdateNotificationToken(this._token) {
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
}
