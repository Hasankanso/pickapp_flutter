import 'package:just_miles/classes/App.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/Request.dart';

class CancelReservedSeats extends Request<bool> {
  Ride _ride;
  String reason;

  CancelReservedSeats(this._ride, {this.reason}) {
    httpPath = "/ReserveBusiness/CancelReserved";
  }

  @override
  bool buildObject(json) {
    return json["deleted"];
  }

  @override
  Map<String, dynamic> getJson() {
    Person person = App.user.person;

    return <String, dynamic>{
      'ride': {'id': _ride.id},
      'fullName': person.firstName + " " + person.lastName,
      'reason': reason,
    };
  }
}
