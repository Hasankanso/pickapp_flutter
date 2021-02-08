import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class GetDriverReviews extends Request<Person> {
  Person person;

  GetDriverReviews(this.person) {
    httpPath = "/RateBusiness/GetDriverRate";
  }

  @override
  Person buildObject(json) {
    return null;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'person': person.id,
    };
  }

  @override
  String isValid() {
    return "";
  }
}