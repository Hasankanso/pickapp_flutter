import 'package:just_miles/classes/App.dart';
import "package:just_miles/dataObjects/Ride.dart";
import "package:just_miles/dataObjects/SearchInfo.dart";
import 'package:just_miles/requests/Request.dart';

class SearchForRides extends Request<List<Ride>> {
  SearchInfo _searchInfo;
  SearchForRides(this._searchInfo) {
    httpPath = "/ReserveBusiness/SearchRides";
  }

  @override
  List<Ride> buildObject(json) {
    return json != null ? List<Ride>.from(json.map((x) => Ride.fromJson(x))) : null;
  }

  @override
  Map<String, dynamic> getJson() {
    var json = _searchInfo.toJson();
    if (App.user != null) {
      json["id"] = App.user.id;
    }
    return json;
  }

  @override
  String isValid() {
    return null;
  }
}
