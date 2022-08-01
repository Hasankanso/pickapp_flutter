import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/BaseDataObject.dart';

part 'Car.g.dart';

@HiveType(typeId: 0)
class Car extends BaseDataObject {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _name;
  @HiveField(2)
  int _color;
  @HiveField(3)
  String _brand;
  @HiveField(4)
  String carPictureUrl;
  @HiveField(5)
  int _year;
  @HiveField(6)
  int _maxLuggage;
  @HiveField(7)
  int _maxSeats;
  @HiveField(8)
  DateTime _updated;
  @HiveField(9)
  int _type;

  ImageProvider _networkImage;

  set networkImage(ImageProvider value) {
    _networkImage = value;
  }

  Car({
    String id,
    String name,
    int color,
    String brand,
    int type,
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
        'picture': this.carPictureUrl,
      };

  factory Car.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    var updatedJ = json["updated"];
    DateTime updated;
    if (updatedJ != null) {
      updated = DateTime.fromMillisecondsSinceEpoch(updatedJ, isUtc: true);
    }
    Car c = Car(
        id: json["objectId"],
        name: json["name"],
        type: json["type"],
        year: json['year'],
        maxLuggage: json['maxLuggage'],
        maxSeats: json['maxSeats'],
        brand: json["brand"],
        color: json["color"],
        carPictureUrl: json["picture"],
        updated: updated);
    c.setNetworkImage();
    return c;
  }

  ImageProvider get networkImage => _networkImage;

  setNetworkImage() {
    if (carPictureUrl == null) {
      this._networkImage = new AssetImage("lib/images/car.png");
    } else {
      this._networkImage = new NetworkImage(
        this.carPictureUrl,
      );
    }
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  int get type => _type;

  set type(int value) {
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
    return car != null && id == car.id;
  }

  @override
  String toString() {
    return 'Car{_id: $_id, _name: $_name, _color: $_color, _brand: $_brand, picture: $carPictureUrl, _year: $_year, _maxLuggage: $_maxLuggage, '
        '_maxSeats: $_maxSeats, _updated: $_updated, _type: $_type}';
  }

  static String get boxName => "cars";
}
