import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/requests/Request.dart';

class EditAccount extends Request<Person> {
  Person _newPerson;
  String _email;

  EditAccount(this._newPerson, this._email) {
    httpPath = "/PersonBusiness/EditPerson";
  }

  @override
  Person buildObject(json) {
    App.user.email = json["email"];
    //todo sett email in chache
    //Cache.SetEmail(Program.User.Email);
    return Person.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var personJ = _newPerson.toJson();
    personJ['user'] = App.user.id;
    personJ['email'] = _email;
    return personJ;
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (Validation.isNullOrEmpty(_newPerson.firstName) ||
        !Validation.isAlphabet(_newPerson.firstName)) {
      return "Your first name must be alphabet only";
    }
    if (Validation.isNullOrEmpty(_newPerson.lastName) ||
        !Validation.isAlphabet(_newPerson.lastName)) {
      return "Your last name must be alphabet only";
    }
    if (Validation.isNullOrEmpty(_email) || !Validation.validEmail(_email)) {
      return "Invalid Email address";
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
