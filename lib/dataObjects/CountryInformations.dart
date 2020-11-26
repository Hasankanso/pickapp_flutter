class CountryInformations {
  String _id, _unit, _name, _countryComponent, _code;
  int _digits;
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
  CountryInformations.fromJson(Map<String, dynamic> json)
      : _id = json["objectId"],
        _name = json["name"],
        _code = json["code"],
        _unit = json["unit"],
        _countryComponent = json["countryComponent"],
        _digits = json["digits"];

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
