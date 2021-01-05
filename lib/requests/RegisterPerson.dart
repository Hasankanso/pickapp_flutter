import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class RegisterPerson extends Request<User> {
  User _newUser;
  String _verificationToken;

  RegisterPerson(this._newUser, this._verificationToken) {
    httpPath = "/UserBusiness/Register";
  }

  @override
  User buildObject(json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var personJ = _newUser.toJson();

    if (!Validation.isNullOrEmpty(_newUser.person.image)) {
      personJ["image"] = _newUser.person.image;
    }
    return <String, dynamic>{'person': personJ, 'idToken': _verificationToken};
  }

  @override
  String isValid() {
    return null;
  }
}
