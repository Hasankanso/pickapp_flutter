import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/classes/core/User.dart';

class SearchInfo {
  Location _from, _to;
  DateTime _minDate, _maxDate;
  int _passengersNumber;
  int _luggagesNumber;
  User _user;

  Location get from => _from;

  set from(Location value) {
    _from = value;
  }

  SearchInfo({from, to, minDate, maxDate, passengersNumber}) {
    this.from = from;
    this.to = to;
    this.minDate = minDate;
    this.maxDate = maxDate;
    this.passengersNumber = passengersNumber;
  }
/*

  public JObject ToJson()
  {

    JObject searchJ = new JObject();

    JObject f = from.ToJson();
    JObject t = To.ToJson();

    searchJ[nameof(from)] = f;
    searchJ[nameof(to)] = t;
    searchJ[nameof(minDate)] = minDate;
    searchJ[nameof(maxDate)] = MaxDate;
    searchJ[nameof(passengersNumber)] = PassengersNumber;

    return searchJ;
  }*/

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
