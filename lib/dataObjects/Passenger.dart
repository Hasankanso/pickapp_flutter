import 'package:pickapp/DataObjects/Person.dart';

class Passenger {
  Person _person;
  String _id;
  int _luggages, _seats;
  DateTime _updated;
  Passenger({person, luggages, seats, id}) {
    this.id = id;
    this.person = person;
    this.seats = seats;
    this.luggages = luggages;
  }
/*
  public static Passenger ToObject(JObject json) {
    string did = "";
    var dId = json["objectId"];
    if (dId != null) did = dId.ToString();

    int seats = -1;
    var sJ = json[nameof(Passenger.seats)];
    if (sJ != null)
      int.TryParse(sJ.ToString(), out seats);

    int luggages = -1;
    var lJ = json[nameof(Passenger.luggages)];
    if (lJ != null)
      int.TryParse(lJ.ToString(), out luggages);

    JObject personJ = (JObject)json["person"];
    Person person = null;
    if (personJ == null) {
      person = Program.Person;
    } else {
      person = Person.ToObject(personJ);

    }
    return new Passenger(person, luggages, seats, did);
  }*/

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
