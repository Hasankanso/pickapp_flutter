class CountryInformations {
  String _id, _unit, _name, _countryComponent, _code;
  int _digits;
  DateTime _updated;

  CountryInformations({id, unit, name, digits, code, countryComponent}) {
    this.id = id;
    this.unit = unit;
    this.name = name;
    this.digits = digits;
    this.code = code;
    this.countryComponent = countryComponent;
  }
/*
public JObject ToJson() {
  JObject countryInformationsJ = new JObject();
  countryInformationsJ[nameof(this.id)] = this.Id;
  return countryInformationsJ;
}*/ /*
public static CountryInformations ToObject(JObject json) {
  string id = "";
  var oId = json["objectId"];
  if (oId != null)
    id = oId.ToString();
  string name = "";
  var nm = json["name"];
  if (nm != null)
    name = nm.ToString();
  string code = "";
  var cd = json["code"];
  if (cd != null)
    code = cd.ToString();
  string unit = "";
  var un = json["unit"];
  if (un != null)
    unit = un.ToString();
  string countryComponent = "";
  var cc = json["countryComponent"];
  if (cc != null)
    countryComponent = cc.ToString();
  int digits = -1;
  var dj = json[nameof(CountryInformations.digits)];
  if (dj != null)
    int.TryParse(dj.ToString(), out digits);
  return new CountryInformations(id, unit, name, digits, code, countryComponent);
}*/
  static bool equal(countriesKeys, countryName) {
    if (countriesKeys.Equals(countryName)) return true;
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
