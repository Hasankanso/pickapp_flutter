import 'dart:core';

import 'package:pickapp/classes/App.dart';

class Car {
  String _id, _name, _color, _brand, _carPictureUrl, _pictureBase64;
  int _year, _maxLuggage, _maxSeats;
  //private Texture2D picture;
  DateTime _updated;

  Car({
    id,
    name,
    color,
    brand,
    carPictureUrl,
    year,
    maxLuggage,
    maxSeats,
    pictureBase64,
    updated,
  }) {
    this.id = id;
    this.name = name;
    this.color = color;
    this.brand = brand;
    this.carPictureUrl = carPictureUrl;
    this.year = year;
    this.maxLuggage = maxLuggage;
    this.maxSeats = maxSeats;
    this.pictureBase64 = pictureBase64;
    this.updated = updated;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'year': year,
        'maxLuggage': this.maxLuggage,
        'maxSeats': this.maxSeats,
        'brand': this.brand,
        'name': this.name,
        'color': this.color,
        //'picture': this.pictureBase64,
      };

  Car.fromJson(Map<String, dynamic> json)
      : _id = json["objectId"],
        _name = json["name"],
        _year = json['year'],
        _maxLuggage = json['maxLuggage'],
        _maxSeats = json['maxSeats'],
        _brand = json["brand"],
        _color = json["color"],
        _carPictureUrl = json["picture"];

  static String Validate(Car car) {
    if (car.year > DateTime.now().year || car.year < 1900)
      return "Please enter a valid car year";
    if (car.maxLuggage < 0 || car.maxLuggage > 10) {
      return "Max luggage must be less or equal 10";
    }
    if (car.maxSeats < 0 || car.maxSeats > 50) {
      return "Max seats must be less or equal 50";
    }
    if (App.isNullOrEmpty(car.name) || car.name.length < 2) {
      return "Invalid car name";
    }

    if (App.isNullOrEmpty(car.brand) || car.brand.length < 2) {
      return "Invalid car brand";
    }

    var regexItem = new RegExp("/^#[0-9A-F]{6}");
    if (regexItem.hasMatch(car.color)) {
      return "Invalid color";
    }
    if (App.isNullOrEmpty(car.pictureBase64)) {
      return "Please enter your car picture";
    }
    return null;
  }

  bool Equals(Object obj) {
    var car = obj as Car;
    return car != null &&
        id == car.id &&
        year == car.year &&
        maxLuggage == car.maxLuggage &&
        maxSeats == car.maxSeats &&
        name == car.name &&
        color == car.color &&
        brand == car.brand;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }

  get maxSeats => _maxSeats;

  set maxSeats(value) {
    _maxSeats = value;
  }

  get maxLuggage => _maxLuggage;

  set maxLuggage(value) {
    _maxLuggage = value;
  }

  int get year => _year;

  set year(int value) {
    _year = value;
  }

  get pictureBase64 => _pictureBase64;

  set pictureBase64(value) {
    _pictureBase64 = value;
  }

  get carPictureUrl => _carPictureUrl;

  set carPictureUrl(value) {
    _carPictureUrl = value;
  }

  get brand => _brand;

  set brand(value) {
    _brand = value;
  }

  get color => _color;

  set color(value) {
    _color = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }
}
