import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/requests/Request.dart';

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
    return _newPerson.toJson();
  }

  @override
  String isValid() {
    return null;
  }
}
