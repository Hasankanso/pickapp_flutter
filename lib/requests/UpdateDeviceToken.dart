import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/requests/Request.dart';

class UpdateDeviceToken extends Request<String> {

  final String newToken;
  final Person person;
  UpdateDeviceToken(this.newToken, this.person) {
    httpPath = "/PersonBusiness/UpdateDeviceToken";
  }
  @override
  String buildObject(json) {
    return json["token"].toString();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'token': this.newToken,
      'id': this.person.id,
    };
  }

  @override
  String isValid() {
    return null;
  }
}
