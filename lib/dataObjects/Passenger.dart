import 'package:pickapp/dataObjects/Person.dart';

class Passenger {
  Person _person;
  String _id;
  int _luggages, _seats;
  DateTime _updated;
  Passenger(
      {Person person, int luggages, int seats, String id, DateTime updated}) {
    this.id = id;
    this.updated = updated;
    this.person = person;
    this.seats = seats;
    this.luggages = luggages;
  }
  factory Passenger.fromJson(Map<String, dynamic> json) {
    var creationDateJ = json["creationDate"];
    DateTime creationDate;
    if (creationDateJ != null) {
      creationDate = DateTime.fromMillisecondsSinceEpoch(creationDateJ);
    }
    return Passenger(
        id: json["objectId"],
        seats: json["seats"],
        luggages: json["luggages"],
        person: Person.fromJson(json["person"]));
  }

  Person get person => _person;

  set person(Person value) {
    _person = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }

  get seats => _seats;

  set seats(value) {
    _seats = value;
  }

  int get luggages => _luggages;

  set luggages(int value) {
    _luggages = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
