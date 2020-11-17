import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/DataObjects/User.dart';

class Alert {
  String _id, _comment;
  Location _from, _to;
  DateTime _minDate, _maxDate, _updated;
  int _numberOfPersons, _numberOfLuggage;
  double _price;
  User _user;

  Alert(
      {id,
      user,
      from,
      to,
      price,
      minDate,
      maxDate,
      numberOfPersons,
      numberOfLuggages,
      comment,
      updated}) {
    this.id = id;
    this.user = user;
    this.from = from;
    this.to = to;
    this.minDate = minDate;
    this.updated = updated;
    this.maxDate = maxDate;
    this.numberOfPersons = numberOfPersons;
    this.numberOfLuggage = numberOfLuggages;
    this.price = price;
    this.comment = comment;
  }
/*
  public JObject ToJson() {
    JObject alertJ = new JObject();
    alertJ[nameof(from)] = this.from.ToJson();
    alertJ[nameof(user)] = user.id;
    alertJ[nameof(to)] = this.to.ToJson();
    alertJ[nameof(price)] = price;
    alertJ[nameof(minDate)] = minDate;
    alertJ[nameof(maxDate)] = maxDate;
    alertJ[nameof(numberOfPersons)] = numberOfPersons;
    alertJ[nameof(numberOfLuggage)] = numberOfLuggage;
    alertJ[nameof(comment)] = comment;


    return alertJ;
  }*/ /*
  public static Alert ToObject(JObject json) {
    string id = "";
    var oId = json["objectId"];
    if (oId != null)
      id = oId.ToString();

    Location from = Location.ToObject((JObject)json[nameof(Alert.from)]);
    Location to = Location.ToObject((JObject)json[nameof(Alert.to)]);

    double minDateDouble = -1;
    var mid = json[nameof(Alert.minDate)];
    if (mid != null) {
    double.TryParse(mid.ToString(), out minDateDouble);
    }

    DateTime minDate = Program.UnixToUtc(minDateDouble);

    double maxDateDouble = -1;
    var md = json[nameof(Alert.maxDate)];
    if (md != null) {
    double.TryParse(md.ToString(), out maxDateDouble);
    }

    DateTime maxDate = Program.UnixToUtc(maxDateDouble);

    string comment = "";
    var c = json[nameof(Alert.comment)];
    if (c != null)
    comment = c.ToString();

    string price = "";
    var p = json[nameof(price)];
    if (p != null)
    price = p.ToString();

    int numberOfPersons = -1;
    var nP = json[nameof(Alert.numberOfPersons)];
    if (nP != null)
    int.TryParse(nP.ToString(), out numberOfPersons);
    int numberOfLuggage = -1;
    var nl = json[nameof(Alert.numberOfLuggage)];
    if (nl != null)
    int.TryParse(nl.ToString(), out numberOfLuggage);

    return new Alert(id,from,to,price,minDate,maxDate,numberOfPersons,numberOfLuggage,comment);
  }*/
  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get comment => _comment;

  set comment(value) {
    _comment = value;
  }

  Location get from => _from;

  set from(Location value) {
    _from = value;
  }

  get to => _to;

  set to(value) {
    _to = value;
  }

  DateTime get minDate => _minDate;

  set minDate(DateTime value) {
    _minDate = value;
  }

  get maxDate => _maxDate;

  set maxDate(value) {
    _maxDate = value;
  }

  get updated => _updated;

  set updated(value) {
    _updated = value;
  }

  int get numberOfPersons => _numberOfPersons;

  set numberOfPersons(int value) {
    _numberOfPersons = value;
  }

  get numberOfLuggage => _numberOfLuggage;

  set numberOfLuggage(value) {
    _numberOfLuggage = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }
}
