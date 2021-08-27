import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/requests/Request.dart';

class RemoveAccount extends Request<Person> {
  Person _person;

  RemoveAccount(this._person) {
    httpPath = "";
  }

  @override
  Person buildObject(json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'id': _person.id,
    };
  }

  @override
  String isValid() {
    // TODO: implement isValid
    return null;
  }
}
