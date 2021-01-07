import 'package:pickapp/classes/App.dart';
import 'package:pickapp/requests/Request.dart';

class SendContactUs extends Request<String> {
  String _subject, _message;
  SendContactUs(this._subject, this._message) {
    httpPath = "/UserBusiness/ContactUs";
  }
  @override
  String buildObject(json) {
    return json["received"].toString();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'user': {
        'email': App.user.email,
        'phone': App.user.phone,
        'person': {
          'firstName': App.person.firstName,
          'lastName': App.person.lastName,
        }
      },
      'subject': this._subject,
      'message': this._message
    };
  }

  @override
  String isValid() {
    return null;
  }
}
