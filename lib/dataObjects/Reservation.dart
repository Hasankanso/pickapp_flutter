import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'Reservation.g.dart';

@HiveType(typeId: 4)
class Reservation {
  @HiveField(0)
  Person person;
  @HiveField(1)
  String id;
  @HiveField(2)
  int luggage;
  @HiveField(3)
  int seats;
  @HiveField(4)
  DateTime updated;
  @HiveField(5)
  String rideId;
  @HiveField(6)
  String status;
  @HiveField(7)
  String reason;

  Reservation(
      {Person person,
      int luggage,
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
    this.luggage = luggage;
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
        id: json["objectId"],
        seats: json["seats"],
        luggage: json["luggages"],
        rideId: json["rideId"],
        status: json["status"],
        reason: json["reason"],
        person: Person.fromJson(json["person"]));
  }

  Reservation copy() {
    return Reservation(
        id: this.id,
        seats: this.seats,
        luggage: this.luggage,
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
          seats.toString() +
          ", luggage: " +
          luggage.toString();
    else
      return "id $id " +
          "person: " +
          person.toString() +
          " seats: " +
          seats.toString() +
          ", "
              "luggage: " +
          luggage.toString();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
