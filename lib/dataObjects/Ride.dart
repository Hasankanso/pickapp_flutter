import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';

part 'Ride.g.dart';

@HiveType(typeId: 7)
class Ride {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _comment;
  @HiveField(2)
  String _mapBase64;
  @HiveField(3)
  MainLocation _from;
  @HiveField(4)
  MainLocation _to;
  @HiveField(5)
  DateTime _leavingDate;
  @HiveField(6)
  bool _musicAllowed;
  @HiveField(7)
  bool _acAllowed;
  @HiveField(8)
  bool _smokingAllowed;
  @HiveField(9)
  bool _petsAllowed;
  @HiveField(10)
  bool _kidSeat;
  @HiveField(11)
  bool _reserved;
  @HiveField(12)
  int _availableSeats;
  @HiveField(13)
  int _maxSeats;
  @HiveField(14)
  int _maxLuggages;
  @HiveField(15)
  int _reservedSeats;
  @HiveField(16)
  int _availableLuggages;
  @HiveField(17)
  int _reservedLuggages;
  @HiveField(18)
  int _stopTime;
  @HiveField(19)
  int _price;
  @HiveField(20)
  User _user;
  @HiveField(21)
  List<Passenger> _passengers;
  @HiveField(22)
  Car _car;
  @HiveField(23)
  DateTime _updated;

  @HiveField(24)
  String _mapUrl;

  ImageProvider _mapImage;

  Ride(
      {String id,
      String comment,
      String mapUrl,
      String mapBase64,
      MainLocation from,
      MainLocation to,
      DateTime leavingDate,
      bool musicAllowed,
      bool acAllowed,
      bool smokingAllowed,
      bool petsAllowed,
      bool kidSeat,
      bool reserved,
      int availableSeats,
      int maxSeats,
      int maxLuggages,
      int reservedSeats,
      int availableLuggages,
      int reservedLuggages,
      int stopTime,
      List<Passenger> passengers,
      int price,
      User user,
      Car car,
      DateTime updated}) {
    this.id = id;
    this.comment = comment;
    this.from = from;
    this.to = to;
    this.leavingDate = leavingDate;
    this.musicAllowed = musicAllowed;
    this.acAllowed = acAllowed;
    this.smokingAllowed = smokingAllowed;
    this.petsAllowed = petsAllowed;
    this.kidSeat = kidSeat;
    this.reserved = reserved;
    this.availableSeats = availableSeats;
    this.maxSeats = maxSeats;
    this.maxLuggages = maxLuggages;
    this.reservedSeats = reservedSeats;
    this.availableLuggages = availableLuggages;
    this.reservedLuggages = reservedLuggages;
    this.stopTime = stopTime;
    this.price = price;
    this.user = user;
    this.passengers = passengers;
    this.car = car;
    this.updated = updated;
    this.mapBase64 = mapBase64;
    this._mapUrl = mapUrl;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ride && runtimeType == other.runtimeType && _id == other._id;

  @override
  int get hashCode => _id.hashCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'kidSeat': this.kidSeat,
        "acAllowed": this.acAllowed,
        "musicAllowed": this.musicAllowed,
        "smokingAllowed": this.smokingAllowed,
        "petsAllowed": this.petsAllowed,
        "availableLuggages": this.availableLuggages,
        "availableSeats": this.availableSeats,
        "maxSeats": this.maxSeats,
        "maxLuggages": this.maxLuggages,
        "stopTime": this.stopTime,
        "leavingDate": this.leavingDate,
        "car": this.car.id,
        "comment": this.comment,
        "user": App.user.id,
        "price": this.price,
        "to": this.to.toJson(),
        "from": this.from.toJson(),
        "map": this.mapBase64
      };

  @override
  String toString() {
    return 'Ride{_id: $_id, _comment: $_comment, _mapBase64: $_mapBase64, _from: $_from, _to: $_to, _leavingDate: $_leavingDate, _musicAllowed: $_musicAllowed, _acAllowed: $_acAllowed, _smokingAllowed: $_smokingAllowed, _petsAllowed: $_petsAllowed, _kidSeat: $_kidSeat, _reserved: $_reserved, _availableSeats: $_availableSeats, _maxSeats: $_maxSeats, _maxLuggages: $_maxLuggages, _reservedSeats: $_reservedSeats, _availableLuggages: $_availableLuggages, _reservedLuggages: $_reservedLuggages, _stopTime: $_stopTime, _price: $_price, _user: $_user, _passengers: $_passengers, _car: $_car, _updated: $_updated, _mapUrl: $_mapUrl, mapImage: $mapImage}';
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    var leavingDateJ = json["leavingDate"];
    DateTime leavingDate;
    if (leavingDateJ != null) {
      leavingDate =
          DateTime.fromMillisecondsSinceEpoch(leavingDateJ, isUtc: true);
    }

    User user;
    bool reserved;
    if (json["driver"] != null && json["driver"] != "") {
      Map<String, dynamic> driverJ = json["driver"];
      Driver driver = Driver.fromJson(driverJ);
      Person person = Person.fromJson(driverJ["person"]);
      user = User(person: person, driver: driver);
      reserved = true;
    } else {
      reserved = false;
    }

    Ride r = new Ride(
      kidSeat: json["kidSeat"],
      id: json["objectId"],
      acAllowed: json["acAllowed"],
      musicAllowed: json["musicAllowed"],
      smokingAllowed: json["smokingAllowed"],
      petsAllowed: json["petsAllowed"],
      availableLuggages: json["availableLuggages"],
      maxSeats: json["maxSeats"],
      maxLuggages: json["maxLuggages"],
      availableSeats: json["availableSeats"],
      stopTime: json["stopTime"] == null ? 0 : json["stopTime"],
      comment: json["comment"],
      user: user,
      car: Car.fromJson(json["car"]),
      reserved: reserved,
      passengers: json["passengers"] != null
          ? List<Passenger>.from(
              json["passengers"].map((x) => Passenger.fromJson(x)))
          : null,
      leavingDate: leavingDate,
      reservedLuggages: json["reservedLuggages"],
      reservedSeats: json["reservedSeats"],
      from: MainLocation.fromJson(json["from"]),
      to: MainLocation.fromJson(json["to"]),
      price: json["price"],
      mapBase64: json["map"],
      mapUrl: json["map"],
    );

    r.setMapImage();

    return r;
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get mapBase64 => _mapBase64;

  set mapBase64(String value) {
    _mapBase64 = value;
  }

  Passenger reservationOf (Person person) {
    for (Passenger p in passengers) {
      if (p.person == person) {
        return p;
      }
    }
    return null;
  }

  get comment => _comment;

  set comment(value) {
    _comment = value;
  }

  setMap(File value) async {
    if (value != null) {
      List<int> imageBytes = await value.readAsBytesSync();
      _mapBase64 = await base64Encode(imageBytes);
    }
  }

  MainLocation get from => _from;

  set from(MainLocation value) {
    _from = value;
  }

  MainLocation get to => _to;

  set to(MainLocation value) {
    _to = value;
  }

  DateTime get leavingDate => _leavingDate;

  set leavingDate(DateTime value) {
    _leavingDate = value;
  }

  bool get musicAllowed => _musicAllowed;

  set musicAllowed(bool value) {
    _musicAllowed = value;
  }

  get acAllowed => _acAllowed;

  set acAllowed(value) {
    _acAllowed = value;
  }

  get smokingAllowed => _smokingAllowed;

  set smokingAllowed(value) {
    _smokingAllowed = value;
  }

  get petsAllowed => _petsAllowed;

  set petsAllowed(value) {
    _petsAllowed = value;
  }

  get kidSeat => _kidSeat;

  set kidSeat(value) {
    _kidSeat = value;
  }

  get reserved => _reserved;

  set reserved(value) {
    _reserved = value;
  }

  int get availableSeats => _availableSeats;

  set availableSeats(int value) {
    _availableSeats = value;
  }

  get maxSeats => _maxSeats;

  set maxSeats(value) {
    _maxSeats = value;
  }

  get maxLuggages => _maxLuggages;

  set maxLuggages(value) {
    _maxLuggages = value;
  }

  get reservedSeats => _reservedSeats;

  set reservedSeats(value) {
    _reservedSeats = value;
  }

  get availableLuggages => _availableLuggages;

  set availableLuggages(value) {
    _availableLuggages = value;
  }

  get reservedLuggages => _reservedLuggages;

  set reservedLuggages(value) {
    _reservedLuggages = value;
  }

  get stopTime => _stopTime;

  set stopTime(value) {
    _stopTime = value;
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Car get car => _car;

  set car(Car value) {
    _car = value;
  }

  String get mapUrl => _mapUrl;

  set mapUrl(String value) {
    _mapUrl = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }

  List<Passenger> get passengers => _passengers;

  set passengers(List<Passenger> value) {
    _passengers = value;
  }

  ImageProvider get mapImage {
    return _mapImage;
  }

  setMapImage() {
    if (_mapUrl == null) {
      this._mapImage = new AssetImage("lib/images/map.jpg");
    } else {
      this._mapImage = new NetworkImage(this.mapUrl);
    }
  }

  CountryInformations get countryInformations => person.countryInformations;

  Driver get driver => user.driver;

  Person get person => user.person;
}
