import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Passenger.g.dart';

@HiveType(typeId: 4)
class Passenger {
  @HiveField(0)
  Person _person;
  @HiveField(1)
  String _id;
  @HiveField(2)
  int _luggages;
  @HiveField(3)
  int _seats;
  @HiveField(4)
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
      creationDate =
          DateTime.fromMillisecondsSinceEpoch(creationDateJ, isUtc: true);
    }

    return Passenger(
        id: json["objectId"],
        seats: json["seats"],
        luggages: json["luggages"],
        person: Person.fromJson(json["person"]));
  }

  @override
  String toString() {
    if (person != null)
      return "person: " +
          person.firstName +
          ", seats: " +
          _seats.toString() +
          ", luggage: " +
          _luggages.toString();
    else
      return " seats: " +
          _seats.toString() +
          ", luggage: " +
          _luggages.toString();
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
