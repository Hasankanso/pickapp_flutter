import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class GetDriverReviews extends Request<List<Rate>> {
  Person person;

  GetDriverReviews(this.person) {
    httpPath = "/RateBusiness/GetDriverRate";
  }

  @override
  List<Rate> buildObject(json) {
    return json != null
        ? List<Rate>.from(json.map((x) => Rate.fromJson(x)))
        : null;
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