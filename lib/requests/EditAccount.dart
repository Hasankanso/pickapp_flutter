import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/requests/Request.dart';

class EditAccount extends Request<Person> {
  Person _newPerson;

  EditAccount(this._newPerson) {
    httpPath = "/PersonBusiness/EditPerson";
  }

  @override
  Person buildObject(json) {
    return Person.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var personJ = _newPerson.toJson();
    personJ['user'] = App.user.id;
    return personJ;
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (Validation.isNullOrEmpty(_newPerson.firstName) ||
        !Validation.validAlphabet(_newPerson.firstName)) {
      return "Your first name must be alphabet only";
    }
    if (Validation.isNullOrEmpty(_newPerson.lastName) ||
        !Validation.validAlphabet(_newPerson.lastName)) {
      return "Your last name must be alphabet only";
    }
    if (App.calculateAge(_newPerson.birthday) < 14) {
      return "You are out of legal age.";
    }
    if (Validation.isNullOrEmpty(_newPerson.countryInformations.id)) {
      return "Please choose your country";
    }
    return null;
  }
}
