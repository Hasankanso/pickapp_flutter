import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/requests/Request.dart';

class GetReservation extends Request<Reservation> {
  String reservationId;
  String rideId;

  GetReservation(this.reservationId, this.rideId) {
    httpPath = "/ReserveBusiness/GetReservation";
  }

  @override
  Reservation buildObject(json) {
    return Reservation.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, String>{"objectId": reservationId, "ride": rideId};
  }
}
