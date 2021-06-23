import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/requests/Request.dart';

class GetUserReviews extends Request<List<Rate>> {
  Person person;

  GetUserReviews(this.person) {
    httpPath = "/RateBusiness/GetUserReviews";
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
