import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/requests/Request.dart';

class GetPerson extends Request<Person> {
  String personId;

  GetPerson(this.personId) {
    httpPath = "/PersonBusiness/GetPerson";
  }

  @override
  Person buildObject(json) {
    return Person.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    Map<String, dynamic> json = <String, dynamic>{
      'id': personId,
    };

    return json;
  }

  @override
  String isValid() {
    return "";
  }
}
