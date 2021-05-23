import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Ride.dart';

part 'Rate.g.dart';

@HiveType(typeId: 6)
class Rate {
  @HiveField(0)
  double _grade;
  @HiveField(1)
  String _comment;
  @HiveField(2)
  int _reason;
  @HiveField(3)
  Person _rater;
  @HiveField(4)
  Person _target;
  @HiveField(5)
  Ride _ride;
  @HiveField(6)
  DateTime _creationDate;
  @HiveField(7)
  String id;

  Rate(
      {double grade,
      String comment,
      int reason,
      Person rater,
      Person target,
      Ride ride,
      DateTime creationDate,
      this.id}) {
    this.grade = grade;
    this.comment = comment;
    this.reason = reason;
    this.rater = rater;
    this.target = target;
    this.ride = ride;
    this.creationDate = creationDate;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "comment": this.comment,
        "grade": this.grade,
        "reason": this.reason,
        "user": App.user.id,
        "ride": this.ride.id,
        "target": this.target.id,
        "objectId": this.id
      };
  factory Rate.fromJson(Map<String, dynamic> json) {
    var creationDateJ = json["created"];
    DateTime creationDate;
    if (creationDateJ != null) {
      creationDate =
          DateTime.fromMillisecondsSinceEpoch(creationDateJ, isUtc: true);
    }

    return Rate(
      grade: json["grade"].toDouble(),
      comment: json["comment"],
      reason: json["reason"],
      id: json["objectId"],
      creationDate: creationDate,
      rater: Person.fromJson(json["rater"]),
      target: Person.fromJson(json["target"]),
    );
  }

  @override
  String toString() {
    return 'Rate{_grade: $_grade, _comment: $_comment, _reason: $_reason, _rater: $_rater, _target: $_target, _ride: $_ride, _creationDate: $_creationDate}';
  }

  double get grade => _grade;

  set grade(double value) {
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
}
