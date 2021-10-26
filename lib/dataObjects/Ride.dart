import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/dataObjects/CountryInformations.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/User.dart';

part 'Ride.g.dart';

@HiveType(typeId: 7)
class Ride {
  @HiveField(0)
  String id;
  @HiveField(1)
  String _comment;
  Uint8List imageBytes;
  @HiveField(3)
  MainLocation from;
  @HiveField(4)
  MainLocation to;
  @HiveField(5)
  DateTime leavingDate;
  @HiveField(6)
  bool musicAllowed;
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
  int availableSeats;
  @HiveField(13)
  int maxSeats;
  @HiveField(14)
  int maxLuggage;
  @HiveField(15)
  int availableLuggage;
  @HiveField(16)
  int _stopTime;
  @HiveField(17)
  int _price;
  @HiveField(18)
  User user;
  @HiveField(19)
  List<Reservation> reservations;
  @HiveField(20)
  Car car;
  @HiveField(21)
  DateTime updated;

  @HiveField(22)
  String mapUrl;

  @HiveField(23)
  String status;
  @HiveField(24)
  String reason;

  ImageProvider _mapImage;

  Ride(
      {String id,
      String comment,
      String mapUrl,
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
      int maxLuggage,
      int availableLuggage,
      int stopTime,
      List<Reservation> reservations,
      int price,
      User user,
      Car car,
      DateTime updated,
      this.status,
      this.reason}) {
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
    this.availableLuggages = availableLuggage;

    this.maxSeats = maxSeats;
    this.maxLuggage = maxLuggage;

    this.stopTime = stopTime;
    this.price = price;
    this.user = user;
    this.reservations = reservations;
    this.car = car;
    this.updated = updated;
    this.mapUrl = mapUrl;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Ride && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'kidSeat': this.kidSeat,
        "acAllowed": this.acAllowed,
        "musicAllowed": this.musicAllowed,
        "smokingAllowed": this.smokingAllowed,
        "petsAllowed": this.petsAllowed,
        "availableLuggages": this.availableLuggages,
        "availableSeats": this.availableSeats,
        "maxSeats": this.maxSeats,
        "maxLuggages": this.maxLuggage,
        "stopTime": this.stopTime,
        "leavingDate": this.leavingDate,
        "car": this.car.id,
        "comment": this.comment,
        "price": this.price,
        "to": this.to.toJson(),
        "from": this.from.toJson(),
        "map": this.mapUrl,
        "status": this.status
      };

  Reservation findReservationFrom(Person person) {
    print("looking");
    for (Reservation reserve in this.reservations) {
      if (reserve.person == null || reserve.person == person) {
        // == null part is ugly, need to
        // change
        return reserve;
      }
    }
    return null;
  }

  @override
  String toString() {
    return 'Ride{_id: $id, _comment: $_comment, _mapUrl: $mapUrl, _from: $from,'
        ' _to: $to, _leavingDate: $leavingDate, _musicAllowed: $musicAllowed, _acAllowed: $_acAllowed,'
        ' _smokingAllowed: $_smokingAllowed, _petsAllowed: $_petsAllowed, _kidSeat: $_kidSeat,'
        ' _reserved: $_reserved, _availableSeats: $availableSeats, _maxSeats: $maxSeats, _maxLuggage: $maxLuggage'
        ' _availableLuggage: $availableLuggage, _stopTime: $_stopTime, _price: $_price, _user: $user,'
        ' _passengers: $reservations, _car: $car, _updated: $updated, _mapUrl: $mapUrl, mapImage: $mapImage}';
  }

  factory Ride.fromJson(Map<String, dynamic> json) {
    var leavingDateJ = json["leavingDate"];
    DateTime leavingDate;
    if (leavingDateJ != null && leavingDateJ is int) {
      leavingDate = DateTime.fromMillisecondsSinceEpoch(leavingDateJ, isUtc: true);
    } else {
      leavingDate = DateTime.parse(leavingDateJ);
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
      availableLuggage: json["availableLuggages"],
      maxSeats: json["maxSeats"],
      maxLuggage: json["maxLuggages"],
      availableSeats: json["availableSeats"],
      stopTime: json["stopTime"] == null ? 0 : json["stopTime"],
      comment: json["comment"],
      user: user,
      status: json["status"],
      car: Car.fromJson(json["car"]),
      reserved: reserved,
      reservations: json["passengers"] != null
          ? List<Reservation>.from(json["passengers"].map((x) => Reservation.fromJson(x)))
          : null,
      leavingDate: leavingDate,
      from: MainLocation.fromJson(json["from"]),
      to: MainLocation.fromJson(json["to"]),
      price: json["price"],
      mapUrl: json["map"],
    );

    r.setMapImage();

    return r;
  }

  Ride copy() {
    return new Ride(
        kidSeat: this.kidSeat,
        id: this.id,
        acAllowed: this.acAllowed,
        musicAllowed: this.musicAllowed,
        smokingAllowed: this.smokingAllowed,
        petsAllowed: this.petsAllowed,
        availableLuggage: this.availableLuggages,
        maxSeats: this.maxSeats,
        maxLuggage: this.maxLuggage,
        availableSeats: this.availableSeats,
        stopTime: this.stopTime,
        comment: this.comment,
        user: user,
        status: this.status,
        reserved: reserved,
        reservations: this.reservations != null
            ? List<Reservation>.from(this.reservations.map((x) => x.copy()))
            : null,
        leavingDate: leavingDate,
        from: this.from.copy(),
        to: this.to.copy(),
        price: this.price,
        mapUrl: this.mapUrl,
        updated: this.updated,
        car: this.car,
        reason: this.reason);
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  Reservation reservationOf(Person person) {
    if (reservations == null) return null;
    for (Reservation p in reservations) {
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

  int get reservedSeats {
    return this.maxSeats - this.availableSeats;
  }

  int get availableLuggages => availableLuggage;

  set availableLuggages(value) {
    availableLuggage = value;
  }

  int get reservedLuggages {
    return this.maxLuggage - this.availableLuggage;
  }

  get stopTime => _stopTime;

  set stopTime(value) {
    _stopTime = value;
  }

  ImageProvider get mapImage {
    return _mapImage;
  }

  setMapImage() {
    if (mapUrl == null) {
      this._mapImage = new AssetImage("lib/images/map.jpg");
    } else {
      this._mapImage = new NetworkImage(this.mapUrl);
    }
  }

  CountryInformations get countryInformations => person.countryInformations;

  Driver get driver => user.driver;

  Person get person => user.person;
}
