import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/requests/Request.dart';

class ReportUser extends Request<Person> {
  String _reason, _comment;
  Person _person;

  ReportUser(this._reason, this._comment, this._person) {
    httpPath = "";
  }

  @override
  Person buildObject(json) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'person': {'id': _person.id},
      'reason': _reason,
      'comment': _comment
    };
  }
}
