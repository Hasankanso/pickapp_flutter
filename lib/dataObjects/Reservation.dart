import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Reservation.g.dart';

@HiveType(typeId: 4)
class Reservation {
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
  @HiveField(5)
  String rideId;
  @HiveField(6)
  String status;
  @HiveField(7)
  String reason;

  Reservation(
      {Person person,
      int luggages,
      int seats,
      String id,
      DateTime updated,
      this.rideId,
      this.status,
      this.reason}) {
    this.id = id;
    this.updated = updated;
    this.person = person;
    this.seats = seats;
    this.luggages = luggages;
  }
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
        id: json["objectId"],
        seats: json["seats"],
        luggages: json["luggages"],
        rideId: json["rideId"],
        status: json["status"],
        reason: json["reason"],
        person: Person.fromJson(json["person"]));
  }
  Reservation copy() {
    return Reservation(
        id: this.id,
        seats: this.seats,
        luggages: this.luggages,
        rideId: this.rideId,
        status: this.status,
        reason: this.reason,
        updated: this.updated,
        person: this.person);
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
      return "id $id " +
          "person: " +
          person.toString() +
          " seats: " +
          _seats.toString() +
          ", "
              "luggage: " +
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

  int get seats => _seats;

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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation &&
          runtimeType == other.runtimeType &&
          _id == other._id;

  @override
  int get hashCode => _id.hashCode;
}
