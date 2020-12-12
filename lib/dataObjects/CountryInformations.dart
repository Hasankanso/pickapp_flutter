import 'package:hive/hive.dart';

part 'CountryInformations.g.dart';

@HiveType(typeId: 1)
class CountryInformations {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _unit;
  @HiveField(2)
  String _name;
  @HiveField(3)
  String _countryComponent;
  @HiveField(4)
  String _code;
  @HiveField(5)
  int _digits;
  @HiveField(6)
  DateTime _updated;

  CountryInformations(
      {String id,
      String unit,
      String name,
      int digits,
      String code,
      DateTime updated,
      String countryComponent}) {
    this.id = id;
    this.updated = updated;
    this.unit = unit;
    this.name = name;
    this.digits = digits;
    this.code = code;
    this.countryComponent = countryComponent;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{'id': this.id};
  factory CountryInformations.fromJson(Map<String, dynamic> json) {
    return CountryInformations(
        id: json["objectId"],
        name: json["name"],
        code: json["code"],
        unit: json["unit"],
        countryComponent: json["countryComponent"],
        digits: json["digits"]);
  }

  static bool equal(countriesKey, countryName) {
    if (countriesKey.Equals(countryName)) return true;
    return false;
  }

  @override
  String toString() {
    return _unit;
  }

  get unit => _unit;

  set unit(value) {
    _unit = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get countryComponent => _countryComponent;

  set countryComponent(value) {
    _countryComponent = value;
  }

  get code => _code;

  set code(value) {
    _code = value;
  }

  int get digits => _digits;

  set digits(int value) {
    _digits = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }
}
