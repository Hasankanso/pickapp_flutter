import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Ride.dart';

class Rate {
  int _grade;
  String _comment, _reason;
  Person _rater, _target;
  Ride _ride;
  DateTime _creationDate, _updated;

  Rate(
      {int grade,
      String comment,
      String reason,
      Person rater,
      Person target,
      Ride ride,
      DateTime creationDate,
      DateTime updated}) {
    this.grade = grade;
    this.comment = comment;
    this.reason = reason;
    this.rater = rater;
    this.target = target;
    this.ride = ride;
    this.creationDate = creationDate;
    this.updated = updated;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "comment": this.comment,
        "grade": this.grade,
        "date": this.creationDate,
        "reason": this.reason,
        "user": App.user.id,
        "ride": this.ride.id,
        "target": this.target.id
      };
  factory Rate.fromJson(Map<String, dynamic> json) {
    var creationDateJ = json["creationDate"];
    DateTime creationDate;
    if (creationDateJ != null) {
      creationDate = DateTime.fromMillisecondsSinceEpoch(creationDateJ);
    }
    var updatedJ = json["creationDate"];
    DateTime updated;
    if (updatedJ != null) {
      updated = DateTime.fromMillisecondsSinceEpoch(updatedJ);
    }
    return Rate(
        grade: json["grade"],
        comment: json["comment"],
        reason: json["reason"],
        creationDate: creationDate,
        rater: Person.fromJson(json["rater"]),
        target: Person.fromJson(json["target"]),
        ride: Ride.fromJson(json["ride"]),
        updated: updated);
  }
  static String validate(Rate rate) {
    if (rate.grade == null || rate.grade < 0 || rate.grade > 5) {
      return "Invalid rate";
    }
    if (rate.grade < 3 && Validation.isNullOrEmpty(rate.comment)) {
      return "Please state the reason of low rate";
    }
    if (Validation.isNullOrEmpty(rate.rater.id)) {
      return "Invalid reviewer object id";
    }
    if (Validation.isNullOrEmpty(rate.target.id)) {
      return "Invalid target object id";
    }
    if (Validation.isNullOrEmpty(rate.ride.id)) {
      return "Invalid ride object id";
    }
    return null;
  }

  int get grade => _grade;

  set grade(int value) {
    _grade = value;
  }

  String get comment => _comment;

  set comment(String value) {
    _comment = value;
  }

  get reason => _reason;

  set reason(value) {
    _reason = value;
  }

  Person get rater => _rater;

  set rater(Person value) {
    _rater = value;
  }

  get target => _target;

  set target(value) {
    _target = value;
  }

  Ride get ride => _ride;

  set ride(Ride value) {
    _ride = value;
  }

  DateTime get creationDate => _creationDate;

  set creationDate(DateTime value) {
    _creationDate = value;
  }

  get updated => _updated;

  set updated(value) {
    _updated = value;
  }
}
