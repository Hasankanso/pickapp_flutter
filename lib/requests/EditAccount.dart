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
    return null;
  }
}
