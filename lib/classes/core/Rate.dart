import 'package:pickapp/classes/core/Person.dart';
import 'package:pickapp/classes/core/Ride.dart';

class Rate {
  int _grade;
  String _comment, _reason;
  Person _rater, _target;
  Ride _ride;
  DateTime _creationDate, _updated;

  Rate(grade, comment, reason, rater, target, ride, creationDate, updated) {
    this.grade = grade;
    this.comment = comment;
    this.reason = reason;
    this.rater = rater;
    this.target = target;
    this.ride = ride;
    this.creationDate = creationDate;
    this.updated = updated;
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

/*
public JObject ToJson() {
  JObject rateJ = new JObject();
  rateJ[nameof(this.Comment)] = this.comment;
  rateJ[nameof(this.Grade)] = this.grade;
  rateJ[nameof(this.Date)] = this.creationDate;
  rateJ[nameof(this.reason)] = this.reason;
  rateJ["user"] = Program.User.id;
  rateJ[nameof(this.ride)] = this.ride.Id;
  rateJ[nameof(this.target)] = this.target.Id;
  return rateJ;
}
public static Rate ToObject(JObject json) {
  int grade = -1;
  var oGrade = json[nameof(Rate.grade)];
  if (oGrade != null) int.TryParse(oGrade.ToString(), out grade);
  string comment = "";
  var ocomment = json["comment"];
  if (ocomment != null) comment = ocomment.ToString();
  string reason = "";
  var oReason = json["reason"];
  if (oReason != null) reason = oReason.ToString();

  double creationDate = -1;
  var cD = json[nameof(Rate.creationDate)];
  if (cD != null) {
    double.TryParse(cD.ToString(), out creationDate);
  }
  DateTime creationDate1 = Program.UnixToUtc(creationDate);

  var rater = json["rater"];
  Person rater1 = null;
  if (rater != null && rater.HasValues) {
    rater1 = Person.ToObject((JObject)rater);
  }
  var target = json["target"];
  Person target1 = null;
  if (target != null && target.HasValues) {
    target1 = Person.ToObject((JObject)target);
  }
  var ride = json["ride"];
  Ride ride1 = null;
  if (ride != null && ride.HasValues) {
    ride1 = Ride.ToObject((JObject)ride);
  }
  String updated = "";
  var Oupdated = json["updated"];
  if (Oupdated != null) updated = Oupdated.ToString();

  return new Rate(grade, comment, reason, creationDate1, rater1, ride1, target1);
}
public static string Validate(Rate rate) {
  if (rate.Grade < 0 || rate.Grade > 5) {
    return "Invalid rate";
  }
  if (rate.Grade < 3 && string.IsNullOrEmpty(rate.Comment)) {
    return "Please state the reason of low rate";
  }
  if (string.IsNullOrEmpty(rate.Rater.id)) {
    return "Invalid reviewer object id";
  }
  if (string.IsNullOrEmpty(rate.Target.id)) {
    return "Invalid target object id";
  }
  if (string.IsNullOrEmpty(rate.Ride.id)) {
    return "Invalid ride object id";
  }
  return string.Empty;
}*/

}
