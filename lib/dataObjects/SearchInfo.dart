import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';

part 'SearchInfo.g.dart';

@HiveType(typeId: 8)
class SearchInfo {
  @HiveField(0)
  MainLocation _from;
  @HiveField(1)
  MainLocation _to;
  @HiveField(2)
  DateTime _minDate;
  @HiveField(3)
  DateTime _maxDate;
  @HiveField(4)
  int _passengersNumber;
  @HiveField(5)
  int _luggagesNumber;
  @HiveField(6)
  User _user;
  @HiveField(7)
  List<Ride> _rides;

  SearchInfo(
      {MainLocation from,
      MainLocation to,
      DateTime minDate,
      DateTime maxDate,
      int passengersNumber}) {
    this.from = from;
    this.to = to;
    this.minDate = minDate;
    this.maxDate = maxDate;
    this.passengersNumber = passengersNumber;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'from': this.from.toJson(),
        'to': this.to.toJson(),
        'minDate': this.minDate.toUtc(),
        'maxDate': this.maxDate.toUtc(),
        'passengersNumber': this.passengersNumber,
      };

  MainLocation get from => _from;

  set from(MainLocation value) {
    _from = value;
  }

  MainLocation get to => _to;

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

  int get passengersNumber => _passengersNumber;

  set passengersNumber(int value) {
    _passengersNumber = value;
  }

  int get luggagesNumber => _luggagesNumber;

  set luggagesNumber(int value) {
    _luggagesNumber = value;
  }

  User get user => _user;

  set user(User value) {
    _user = value;
  }

  List<Ride> get rides => _rides;

  set rides(List<Ride> rides) {
    _rides = rides;
  }
}
