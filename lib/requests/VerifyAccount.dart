import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/requests/Request.dart';

class VerifyAccount extends Request<String> {
  String _phoneNumber;
  VerifyAccount(this._phoneNumber) {
    httpPath = "/UserBusiness/RequestCode";
  }

  @override
  String buildObject(json) {
    return json["email"].toString();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'phone': _phoneNumber,
    };
  }

  @override
  String isValid() {
    if (!Validation.validPhoneNumber(_phoneNumber)) {
      return "Invalid phone number";
    }
    return null;
  }
}
