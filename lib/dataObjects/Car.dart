import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:pickapp/classes/Validation.dart';

class Car {
  String _id, _name, _color, _brand, _carPictureUrl, _pictureBase64;
  int _year, _maxLuggage, _maxSeats;
  File _picture;

  DateTime _updated;

  Car(
      {String id,
      String name,
      String color,
      String brand,
      String carPictureUrl,
      int year,
      int maxLuggage,
      int maxSeats,
      String pictureBase64,
      DateTime updated,
      File picture}) {
    this.id = id;
    this.name = name;
    this.color = color;
    this.brand = brand;
    this.carPictureUrl = carPictureUrl;
    this.year = year;
    this.maxLuggage = maxLuggage;
    this.maxSeats = maxSeats;
    this._pictureBase64 = pictureBase64;
    this.updated = updated;
    this._picture = picture;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'year': this.year,
        'maxLuggage': this.maxLuggage,
        'maxSeats': this.maxSeats,
        'brand': this.brand,
        'name': this.name,
        'color': this.color,
        'picture': this.pictureBase64,
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

  static String validate(Car car) {
    if (car.year == null || car.year > DateTime.now().year || car.year < 1900)
      return "Please enter a valid car year";
    if (car.maxLuggage == null || car.maxLuggage < 0 || car.maxLuggage > 10) {
      return "Max luggage must be less or equal 10";
    }
    if (car.maxSeats == null || car.maxSeats < 0 || car.maxSeats > 50) {
      return "Max seats must be less or equal 50";
    }
    if (Validation.isNullOrEmpty(car.name) || car.name.length < 2) {
      return "Invalid car name";
    }

    if (Validation.isNullOrEmpty(car.brand) || car.brand.length < 2) {
      return "Invalid car brand";
    }

    var regexItem = new RegExp("/^#[0-9A-F]{6}");
    if (regexItem.hasMatch(car.color)) {
      return "Invalid color";
    }
    if (Validation.isNullOrEmpty(car.pictureBase64)) {
      return "Please enter your car picture";
    }
    return null;
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

  File get imageFile => _picture;

  setImageFile(File value) async {
    _picture = value;
    if (value != null) {
      List<int> imageBytes = await value.readAsBytesSync();
      _pictureBase64 = base64Encode(imageBytes);
    }
  }

  get pictureBase64 => _pictureBase64;

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

  @override
  bool operator ==(Object other) {
    var car = other as Car;
    return car != null &&
        id == car.id &&
        year == car.year &&
        maxLuggage == car.maxLuggage &&
        maxSeats == car.maxSeats &&
        name == car.name &&
        color == car.color &&
        brand == car.brand;
  }

  @override
  String toString() {
    return "nice one";
  }
}
