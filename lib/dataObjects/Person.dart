import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Ride.dart';

part 'Person.g.dart';

@HiveType(typeId: 5)
class Person {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _firstName;
  @HiveField(2)
  String _lastName;
  @HiveField(3)
  String _bio;
  String _image;
  @HiveField(4)
  String _profilePictureUrl;
  @HiveField(5)
  DateTime _birthday;
  @HiveField(6)
  bool _gender;
  @HiveField(7)
  double _rateAverage;
  @HiveField(8)
  int _acomplishedRides;
  @HiveField(9)
  int _canceledRides;
  @HiveField(10)
  int _rateCount;
  @HiveField(11)
  int _chattiness;
  @HiveField(12)
  List<Ride> _upcomingRides = new List<Ride>();
  @HiveField(13)
  List<Rate> _rates = new List<Rate>();
  @HiveField(14)
  DateTime _updated;
  @HiveField(15)
  CountryInformations _countryInformations;

  ImageProvider networkImage;

  //user
  String _phone;

  Person({
    String id,
    String firstName,
    String lastName,
    int rateCount,
    int acomplishedRides,
    CountryInformations countryInformations,
    int canceledRides,
    int chattiness,
    String phone,
    String bio,
    double rateAverage,
    bool gender,
    DateTime birthday,
    DateTime updated,
    String profilePictureUrl,
  }) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.rateCount = rateCount;
    this.updated = updated;
    this.acomplishedRides = acomplishedRides;
    this.canceledRides = canceledRides;
    this.chattiness = chattiness;
    this.phone = phone;
    this.bio = bio;
    this.countryInformations = countryInformations;
    this.rateAverage = rateAverage;
    this.gender = gender;
    this.birthday = birthday;
    this.profilePictureUrl = profilePictureUrl;
  }

  Person.name(this._firstName, this._lastName);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firstName': this.firstName,
        'lastName': this.lastName,
        'bio': this.bio,
        'image': this.image,
        'chattiness': this.chattiness,
        'countryInformations': this.countryInformations.toJson(),
        'birthday': this.birthday,
        'gender': this.gender,
      };

  factory Person.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;

    var birthdayJ = json["birthday"];
    DateTime birthday;
    if (birthdayJ != null) {
      birthday = DateTime.fromMillisecondsSinceEpoch(birthdayJ);
    }
    var updatedJ = json["updated"];
    DateTime updated;
    if (updatedJ != null) {
      updated = DateTime.fromMillisecondsSinceEpoch(updatedJ);
    }

    var countryJ = json['countryInformations'];
    CountryInformations countryInformations;
    if (countryJ != null) {
      countryInformations = CountryInformations.fromJson(countryJ);
    }

    Person p = Person(
      phone: json['phone'],
      id: json["objectId"],
      updated: updated,
      birthday: birthday,
      firstName: json["firstName"],
      lastName: json["lastName"],
      chattiness: json["chattiness"],
      bio: json["bio"],
      rateAverage: json["rateAverage"].toDouble(),
      acomplishedRides: json['acomplishedRides'],
      canceledRides: json['canceledRides'],
      rateCount: json['rateCount'],
      gender: json['gender'],
      profilePictureUrl: json['image'],
      countryInformations: countryInformations,
    );
    p.networkImage = new NetworkImage(p.profilePictureUrl?? "");
    var upcomingRidesArray = json["upcomingRides"];
    if (upcomingRidesArray != null) {
      p._upcomingRides = List<Ride>.from(upcomingRidesArray.map((x) {
        if (x!=null) {
          if (x.containsKey("ride") && x["ride"].HasValues == true)
            return Ride.fromJson(x["ride"]);
          else
            return Ride.fromJson(x);
        }
      }));
    }
    var ratesArray = json["rates"];
    if (ratesArray != null) {
      p.rates = List<Rate>.from(ratesArray.map((x) {
        if (x != null) {
          return Rate.fromJson(x);
        }
      }));
    }
    return p;
  }

  @override
  String toString() {
    return 'Person{_id: $_id, _firstName: $_firstName, _lastName: $_lastName, _bio: $_bio, _chattiness: $_chattiness, _image: $_image, _profilePictureUrl: $_profilePictureUrl, _birthday: $_birthday, _updated: $_updated, _gender: $_gender, _rateAverage: $_rateAverage, _acomplishedRides: $_acomplishedRides, _canceledRides: $_canceledRides, _rateCount: $_rateCount, _phone: $_phone}';
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  List<Rate> get rates => _rates;

  set rates(List<Rate> value) {
    _rates = value;
  }

  get firstName => _firstName;

  set firstName(value) {
    _firstName = value;
  }

  get lastName => _lastName;

  set lastName(value) {
    _lastName = value;
  }

  get bio => _bio;

  set bio(value) {
    _bio = value;
  }

  get chattiness => _chattiness;

  set chattiness(value) {
    _chattiness = value;
  }

  get image => _image;

  setImage(File value) async {
    if (value != null) {
      List<int> imageBytes = await value.readAsBytesSync();
      _image = await base64Encode(imageBytes);
    }
  }

  get profilePictureUrl => _profilePictureUrl;

  set profilePictureUrl(value) {
    _profilePictureUrl = value;
  }

  DateTime get birthday => _birthday;

  set birthday(DateTime value) {
    _birthday = value;
  }

  get updated => _updated;

  set updated(value) {
    _updated = value;
  }

  bool get gender => _gender;

  set gender(bool value) {
    _gender = value;
  }

  double get rateAverage => _rateAverage;

  set rateAverage(double value) {
    _rateAverage = value;
  }

  int get acomplishedRides => _acomplishedRides;

  set acomplishedRides(int value) {
    _acomplishedRides = value;
  }

  int get canceledRides => _canceledRides;

  set canceledRides(value) {
    _canceledRides = value;
  }

  get rateCount => _rateCount;

  set rateCount(value) {
    _rateCount = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  List<Ride> get upcomingRides => _upcomingRides;

  set upcomingRides(List<Ride> value) {
    _upcomingRides = value;
  }

  CountryInformations get countryInformations => _countryInformations;

  set countryInformations(CountryInformations value) {
    _countryInformations = value;
  }
}
