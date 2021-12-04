import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/requests/Request.dart';

class GetLocation extends Request<MainLocation> {
  MainLocation location;

  GetLocation(this.location) {
    httpPath = "/RideBusiness/GetLocation";
  }

  @override
  MainLocation buildObject(json) {
    return MainLocation.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return location.toJson();
  }
}
