import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import "package:pickapp/dataObjects/Ride.dart";
import "package:pickapp/dataObjects/SearchInfo.dart";
import 'package:pickapp/requests/Request.dart';

class SearchForRides extends Request<List<Ride>> {
  SearchInfo _searchInfo;
  SearchForRides(this._searchInfo) {
    httpPath = "/ReserveBusiness/SearchRides";
  }

  @override
  List<Ride> buildObject(json) {
    return json != null
        ? List<Ride>.from(json.map((x) => Ride.fromJson(x)))
        : null;
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
    String fromValidation = MainLocation.validate(_searchInfo.from);
    if (!Validation.isNullOrEmpty(fromValidation)) {
      return fromValidation;
    }
    String toValidation = MainLocation.validate(_searchInfo.to);
    if (!Validation.isNullOrEmpty(toValidation)) {
      return toValidation;
    }
    if (_searchInfo.minDate.compareTo(DateTime.now()) < 0) {
      return "Min date must be greater than now date";
    }
    if (_searchInfo.minDate.compareTo(_searchInfo.maxDate) > 0) {
      return "Min date must be greater than max date";
    }
    if (_searchInfo.maxDate.compareTo(_searchInfo.minDate) < 0) {
      return "Max date must be smaller than max date";
    }
    if (_searchInfo.passengersNumber < 1 || _searchInfo.passengersNumber > 4) {
      return "Please choose 1 to 8 persons.";
    }
    if (_searchInfo.from.latitude == _searchInfo.to.latitude &&
        _searchInfo.from.longitude == _searchInfo.to.longitude) {
      return "From and To must be different";
    }
    return null;
  }
}
