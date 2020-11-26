import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';

class User {
  String _id, _phone, _email, _verificationCode, _userStatus;
  Person _person;
  Driver _driver;

  User(
      {Person person,
      Driver driver,
      String phone,
      String email,
      String userStatus,
      String id,
      String verificationCode}) {
    this.person = _person;
    this.driver = driver;
    this.id = id;
    this.phone = phone;
    this.email = email;
    this.userStatus = userStatus;
    this.verificationCode = verificationCode;
  }

  bool equals(Object u) {
    return this.person.id == (u as User).person.id;
  }

  static String ValidateLogin(User user) {
    if (App.isNullOrEmpty(user.id)) {
      return "Please login";
    }
    return null;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "phone": this.phone,
        "email": this.email,
        "verificationCode": this.verificationCode,
        "person": this.person.toJson()
      };
  User.fromJson(Map<String, dynamic> json)
      : _id = json["objectId"],
        _phone = json["phone"],
        _email = json["email"],
        _userStatus = json["userStatus"],
        _driver = Driver.fromJson(json["driver"]),
        _person = Person.fromJson(json["person"]);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  get email => _email;

  set email(value) {
    _email = value;
  }

  get verificationCode => _verificationCode;

  set verificationCode(value) {
    _verificationCode = value;
  }

  get userStatus => _userStatus;

  set userStatus(value) {
    _userStatus = value;
  }

  get phone => _phone;

  set phone(value) {
    _phone = value;
  }

  set person(Person value) {
    _person = value;
  }

  Person get person => _person;

  Driver get driver => _driver;

  set driver(Driver value) {
    _driver = value;
  }
}
