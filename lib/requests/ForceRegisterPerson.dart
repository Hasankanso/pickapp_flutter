import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class ForceRegisterPerson extends Request<User> {
  User _newUser;
  String _verificationToken;

  ForceRegisterPerson(this._verificationToken, this._newUser) {
    httpPath = "/UserBusiness/ForceRegister";
  }

  @override
  User buildObject(json) {
    return User.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var personJ = _newUser.toJson();
    if (!Validation.isNullOrEmpty(_newUser.person.image)) {
      personJ['image'] = _newUser.person.image;
    }
    return <String, dynamic>{'person': personJ, 'idToken': _verificationToken};
  }

  @override
  String isValid() {
    if (Validation.isNullOrEmpty(_newUser.person.firstName) ||
        !Validation.isAlphabet(_newUser.person.firstName)) {
      return "Your first name must be alphabet only";
    }
    if (Validation.isNullOrEmpty(_newUser.person.lastName) ||
        !Validation.isAlphabet(_newUser.person.lastName)) {
      return "Your last name must be alphabet only";
    }
    if (Validation.isNullOrEmpty(_newUser.email) ||
        !Validation.validEmail(_newUser.email)) {
      return "Invalid Email address";
    }
    if (App.calculateAge(_newUser.person.birthday) < 14) {
      return "You are out of legal age.";
    }
    if (Validation.isNullOrEmpty(_newUser.person.countryInformations.id)) {
      return "Please choose your country";
    }
    if (Validation.isNullOrEmpty(_verificationToken)) {
      return "Invalid verification token";
    }
    if (!Validation.isPhoneNumber(_newUser.phone)) {
      return "Invalid phone number";
    }
    return null;
  }
}
