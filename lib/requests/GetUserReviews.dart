import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/requests/Request.dart';

class GetUserReviews extends Request<List<Rate>> {
  Person person;

  GetUserReviews({this.person}) {
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
    return person != null
        ? <String, dynamic>{
            'person': person.id,
          }
        : null;
  }
}
