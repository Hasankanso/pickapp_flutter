import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/User.dart';

class Alert {
  String _id, _comment;
  MainLocation _from, _to;
  DateTime _minDate, _maxDate, _updated;
  int _numberOfPersons, _numberOfLuggage;
  double _price;
  User _user;

  Alert(
      {String id,
      User user,
      MainLocation from,
      MainLocation to,
      double price,
      DateTime minDate,
      DateTime maxDate,
      int numberOfPersons,
      int numberOfLuggages,
      String comment,
      DateTime updated}) {
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
  Map<String, dynamic> toJson() => <String, dynamic>{
        "from": from.toJson(),
        "to": to.toJson(),
        "user": user.id,
        "price": price,
        "minDate": minDate,
        "maxDate": maxDate,
        "numberOfPersons": numberOfPersons,
        "numberOfLuggage": numberOfLuggage,
        "comment": comment,
      };
  factory Alert.fromJson(Map<String, dynamic> json) {
    var minDateJ = json["minDate"];
    DateTime minDate;
    if (minDateJ != null) {
      minDate = DateTime.fromMillisecondsSinceEpoch(minDateJ);
    }
    var maxDateJ = json["maxDate"];
    DateTime maxDate;
    if (maxDateJ != null) {
      maxDate = DateTime.fromMillisecondsSinceEpoch(maxDateJ);
    }

    return Alert(
        id: json["objectId"],
        from: MainLocation.fromJson(json["from"]),
        to: MainLocation.fromJson(json["to"]),
        minDate: minDate,
        maxDate: maxDate,
        comment: json["comment"],
        price: json["price"],
        numberOfPersons: json["numberOfPersons"],
        numberOfLuggages: json["numberOfLuggage"]);
  }
  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get comment => _comment;

  set comment(value) {
    _comment = value;
  }

  MainLocation get from => _from;

  set from(MainLocation value) {
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

  DateTime get maxDate => _maxDate;

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
