import 'package:just_miles/dataObjects/MainLocation.dart';

class Alert {
  String _id, _comment;
  MainLocation _from, _to;
  DateTime _leavingDate, _updated;
  int _maxSeats, _maxLuggage;
  double _price;

  Alert(
      {String id,
      MainLocation from,
      MainLocation to,
      double price,
      DateTime leavingDate,
      int maxSeats,
      int maxLuggage,
      String comment,
      DateTime updated}) {
    this.id = id;
    this.from = from;
    this.to = to;
    this.updated = updated;
    this.leavingDate = leavingDate;
    this.maxSeats = maxSeats;
    this.maxLuggage = maxLuggage;
    this.price = price;
    this.comment = comment;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        "from": from.toJson(),
        "to": to.toJson(),
        "price": price,
        "leavingDate": leavingDate,
        "maxSeats": maxSeats,
        "maxLuggage": maxLuggage,
        "comment": comment,
      };
  factory Alert.fromJson(Map<String, dynamic> json) {
    var leavingDateJ = json["leavingDate"];
    DateTime leavingDate;
    if (leavingDateJ != null) {
      leavingDate = DateTime.fromMillisecondsSinceEpoch(leavingDateJ, isUtc: true);
    }

    return Alert(
        id: json["objectId"],
        from: MainLocation.fromJson(json["from"]),
        to: MainLocation.fromJson(json["to"]),
        leavingDate: leavingDate,
        comment: json["comment"],
        price: json["price"],
        maxSeats: json["maxSeats"],
        maxLuggage: json["maxLuggage"]);
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

  DateTime get leavingDate => _leavingDate;

  set leavingDate(value) {
    _leavingDate = value;
  }

  get updated => _updated;

  set updated(value) {
    _updated = value;
  }

  int get maxSeats => _maxSeats;

  set maxSeats(int value) {
    _maxSeats = value;
  }

  get maxLuggage => _maxLuggage;

  set maxLuggage(value) {
    _maxLuggage = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }
}
