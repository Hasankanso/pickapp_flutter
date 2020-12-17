import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:pickapp/classes/Validation.dart';

part 'Car.g.dart';

@HiveType(typeId: 0)
class Car {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _name;
  @HiveField(2)
  int _color;
  @HiveField(3)
  String _brand;
  @HiveField(4)
  String _carPictureUrl;
  @HiveField(5)
  String _pictureBase64;
  @HiveField(6)
  int _year;
  @HiveField(7)
  int _maxLuggage;
  @HiveField(8)
  int _maxSeats;
  @HiveField(9)
  DateTime _updated;
  @HiveField(10)
  String _type;

  Car({
    String id,
    String name,
    String color,
    String brand,
    String type,
    String carPictureUrl,
    int year,
    int maxLuggage,
    int maxSeats,
    String pictureBase64,
    DateTime updated,
  }) {
    this.id = id;
    this.name = name;
    this.color = color;
    this.brand = brand;
    this.type = type;
    this.carPictureUrl = carPictureUrl;
    this.year = year;
    this.maxLuggage = maxLuggage;
    this.maxSeats = maxSeats;
    this._pictureBase64 = pictureBase64;
    this.updated = updated;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'year': this.year,
        'maxLuggage': this.maxLuggage,
        'maxSeats': this.maxSeats,
        'brand': this.brand,
        'name': this.name,
        'type': this.type,
        'color': this.color,
        'picture': this.pictureBase64,
      };

  Car.fromJson(Map<String, dynamic> json)
      : _id = json["objectId"],
        _name = json["name"],
        _type = json["type"],
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
    //todo carr type validation
    if (Validation.isNullOrEmpty(car.type) || car.name.length < 2) {
      return "Invalid car type";
    }
    if (Validation.isNullOrEmpty(car.brand) || car.brand.length < 2) {
      return "Invalid car brand";
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

  String get type => _type;

  set type(String value) {
    _type = value;
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

  setPictureFile(File value) async {
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
    return 'Car{_id: $_id, _name: $_name, _color: $_color, _brand: $_brand, _carPictureUrl: $_carPictureUrl, _pictureBase64: $_pictureBase64, _year: $_year, _maxLuggage: $_maxLuggage, _maxSeats: $_maxSeats, _updated: $_updated, _type: $_type}';
  }
}
