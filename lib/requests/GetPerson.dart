

import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/requests/Request.dart';

class GetPerson extends Request<Person> {

  Person person;

  GetPerson(this.person){
    httpPath = "/PersonBusiness/GetPerson";
  }

  @override
  Person buildObject(json) {
    return Person.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    Map<String, dynamic>  json = <String, dynamic>{
      'id': this.person.id,
    };

    return json;
  }


  @override
  String isValid() {
    return "";
  }



}