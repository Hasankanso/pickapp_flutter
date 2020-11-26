import 'package:pickapp/DataObjects/User.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';

class SearchInfo {
  MainLocation _from, _to;
  DateTime _minDate, _maxDate;
  int _passengersNumber;
  int _luggagesNumber;
  User _user;

  MainLocation get from => _from;

  set from(MainLocation value) {
    _from = value;
  }

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
        'minDate': this.minDate,
        'maxDate': this.maxDate,
        'passengersNumber': this.passengersNumber,
      };

  get to => _to;

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
}
