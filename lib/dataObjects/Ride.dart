import 'dart:convert';
import 'dart:io';

import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';

class Ride {
  String _id, _comment, _mapUrl, _mapBase64;
  MainLocation _from, _to;
  DateTime _leavingDate;
  bool _musicAllowed,
      _acAllowed,
      _smokingAllowed,
      _petsAllowed,
      _kidSeat,
      _reserved;
  int _availableSeats,
      _maxSeats,
      _maxLuggages,
      _reservedSeats,
      _availableLuggages,
      _reservedLuggages,
      _stopTime;

  File _map;
  double _price;
  User _user;
  List<Passenger> _passengers;
  Car _car;
  DateTime _updated;

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
      int maxLuggages,
      int reservedSeats,
      int availableLuggages,
      int reservedLuggages,
      int stopTime,
      List<Passenger> passengers,
      double price,
      User user,
      Car car,
      DateTime updated}) {
    this.id = id;
    this.comment = comment;
    this.mapUrl = mapUrl;
    this.from = from;
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
  }
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
        "user": this.user.id,
        "price": this.price,
        "to": this.to.toJson(),
        "from": this.from.toJson(),
        "map": this.mapBase64
      };

  factory Ride.fromJson(Map<String, dynamic> json) {
    var leavingDateJ = json["leavingDate"];
    DateTime leavingDate;
    if (leavingDateJ != null) {
      leavingDate = DateTime.fromMillisecondsSinceEpoch(leavingDateJ);
    }
    User user;
    if (json["driver"] != null) {
      Driver driver = Driver.fromJson(json["driver"]);
      Person person = Person.fromJson(json["driver"]["person"]);
      user = User(person: person, driver: driver);
    } else {
      user = User(person: App.person, driver: App.driver);
    }
    return Ride(
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
        stopTime: json["stopTime"],
        comment: json["comment"],
        user: user,
        car: Car.fromJson(json["car"]),
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
        mapUrl: json["map"]);
  }

  static String validate(Ride ride) {
    String validateUser = User.ValidateLogin(App.user);
    if (!App.isNullOrEmpty(validateUser)) {
      return validateUser;
    }

    /*String fromValidation = MainLocation.Validate(ride.From);
    if (!App.isNullOrEmpty(fromValidation)) {
      return fromValidation;
    }
    String toValidation = MainLocation.Validate(ride.To);
    if (!App.isNullOrEmpty(toValidation)) {
      return toValidation;
    }*/

    //   if (ride.From.Equals(ride.To))
    //   {
    //       return "From and To are too close (1 km)";
    //   }
    if (ride.from.latitude == ride.to.latitude &&
        ride.from.longitude == ride.to.longitude) {
      return "From and To must be different";
    }
    if (ride.leavingDate.compareTo(DateTime.now().add(Duration(minutes: 30))) <
        0) {
      return "Your ride must be after half our or more from now";
    }
    if (ride.availableSeats == null ||
        ride.availableSeats <= 0 ||
        ride.availableSeats > ride.car.maxSeats) {
      return "Invalid number of seats";
    }
    if (ride.availableLuggages == null ||
        ride.availableLuggages < 0 ||
        ride.availableLuggages > ride.car.maxLuggage) {
      return "Invalid number of luggage";
    }
    if (ride.stopTime != 0 && (ride.stopTime < 5 || ride.stopTime > 30)) {
      return "Your stop time must be between 5 and 30 minutes";
    }
    if (App.isNullOrEmpty(ride.comment) ||
        ride.comment.length < 25 ||
        ride.comment.length > 400) {
      return "Please add a comment between 25 and 400 characters";
    }
    if (App.isNullOrEmpty(ride.mapBase64)) {
      return "Please choose your ride's road";
    }
    if (App.isNullOrEmpty(ride.car.id)) {
      return "Please choose a car";
    }
    if (ride.price == null || ride.price <= 0) {
      return "Please set a price";
    }
    if (App.isNullOrEmpty(ride.countryInformations.id)) {
      return "Please choose a country info";
    }
    if (App.isNullOrEmpty(ride.driver.id)) {
      return "You're not a driver";
    }
    var rideDate = ride.leavingDate.add(Duration(minutes: -20));
    for (final item in App.person.upcomingRides) {
      if (rideDate.compareTo(item.leavingDate) <= 0) {
        return "Your ride must be after 20 min from last upcoming ride";
      }
    }
    return null;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get comment => _comment;

  set comment(value) {
    _comment = value;
  }

  get mapUrl => _mapUrl;

  set mapUrl(value) {
    _mapUrl = value;
  }

  get mapBase64 => _mapBase64;
  File get map => _map;

  setMap(File value) async {
    _map = value;
    if (value != null) {
      List<int> imageBytes = await value.readAsBytesSync();
      _mapBase64 = base64Encode(imageBytes);
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

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  Car get car => _car;

  set car(Car value) {
    _car = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }

  List<Passenger> get passengers => _passengers;

  set passengers(List<Passenger> value) {
    _passengers = value;
  }

  CountryInformations get countryInformations => person.countryInformations;
  Driver get driver => user.driver;
  Person get person => user.person;
}
