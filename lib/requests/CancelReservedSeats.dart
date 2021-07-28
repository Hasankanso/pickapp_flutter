import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';

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
      'user': {'id': App.user.id, 'fullName': person.firstName + " " + person.lastName},
      'reason': reason,
    };
  }

  @override
  String isValid() {
    return null;
  }
}
