import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
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
      'user': App.user.id,
      'subject': this._subject,
      'message': this._message
    };
  }

  @override
  String isValid() {
    if (Validation.isNullOrEmpty(_subject)) {
      return "Subject cannot be empty";
    }
    if (_subject.length < 10) {
      return "Subject is too short.";
    }
    if (Validation.isNullOrEmpty(_message)) {
      return "Message cannot be empty";
    }
    if (_message.length < 70) {
      return "Message is too short.";
    }
    return null;
  }
}
