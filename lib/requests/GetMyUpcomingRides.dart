import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/Request.dart';

class GetMyUpComingRides extends Request<List<Ride>> {
  GetMyUpComingRides() {
    httpPath = "/RideBusiness/GetMyUpcomingRides";
  }

  @override
  List<Ride> buildObject(json) {
    return json != null
        ? List<Ride>.from(json.map((x) => Ride.fromJson(x)))
        : null;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{};
  }

  @override
  String isValid() {
    return null;
  }
}
