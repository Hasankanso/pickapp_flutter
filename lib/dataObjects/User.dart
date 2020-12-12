import 'package:hive/hive.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';

part 'User.g.dart';

@HiveType(typeId: 9)
class User {
  @HiveField(0)
  String _id;
  @HiveField(1)
  String _phone;
  @HiveField(2)
  String _email;
  @HiveField(3)
  String _verificationCode;
  @HiveField(4)
  String _userStatus;
  @HiveField(5)
  Person _person;
  @HiveField(6)
  Driver _driver;

  User(
      {Person person,
      Driver driver,
      String phone,
      String email,
      String userStatus,
      String id,
      String verificationCode}) {
    this.person = person;
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
