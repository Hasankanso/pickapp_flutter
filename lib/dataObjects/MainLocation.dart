import 'dart:core';
import 'dart:math';

import 'package:pickapp/classes/Validation.dart';

class MainLocation {
  String _name, _id, _placeId;
  double _latitude, _longitude;
  DateTime _updated;
  MainLocation(
      {String name,
      String id,
      String placeId,
      double latitude,
      double longitude,
      DateTime updated}) {
    this.name = name;
    this.id = id;
    this.placeId = placeId;
    this.latitude = latitude;
    this.longitude = longitude;
    this.updated = updated;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'placeId': this.placeId,
        'name': this.name,
        'latitude': this.latitude,
        'longitude': this.longitude,
      };

  factory MainLocation.fromJson(Map<String, dynamic> json) {
    var position = json["position"];
    double longitude, latitude;
    if (position != null) {
      var coor = position["coordinates"];
      if (coor != null) {
        longitude = coor[0];
        latitude = coor[1];
      }
    }

    return MainLocation(
        /*id:json["objectId"],*/ name: json["name"],
        placeId: json["placeId"],
        longitude: longitude,
        latitude: latitude);
  }

  bool equals(MainLocation other) {
    return sqrt((longitude - other.longitude) * (longitude - other.longitude) +
            (latitude - other.latitude) * (latitude - other.latitude)) <
        1;
  }

  static String validate(MainLocation location) {
    if (Validation.isNullOrEmpty(location.placeId)) {
      return "Location placeId should not be empty";
    }
    if (Validation.isNullOrEmpty(location.name)) {
      return "Location name should not be empty";
    }
    return null;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }

  get longitude => _longitude;

  set longitude(value) {
    _longitude = value;
  }

  double get latitude => _latitude;

  set latitude(double value) {
    _latitude = value;
  }

  get placeId => _placeId;

  set placeId(value) {
    _placeId = value;
  }

  get id => _id;

  set id(value) {
    _id = value;
  }

  @override
  String toString() {
    return 'Location{_name: $_name, _id: $_id, _placeId: $_placeId, _latitude: $_latitude, _longitude: $_longitude, _updated: $_updated}';
  }
}
