import 'package:hive/hive.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/Person.dart';

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

  String idToken; //this is for firebase phone verification, on register.

  @HiveField(7)
  String password;
  @HiveField(8)
  String sessionToken; //backendless session token.

  bool isExistChecked = false;

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

  @override
  String toString() {
    return 'User{_id: $_id, _phone: $_phone, _email: $_email, _verificationCode: $_verificationCode, _userStatus: $_userStatus, _person: $_person, _driver: $_driver}';
  }

  bool equals(Object u) {
    return this.person.id == (u as User).person.id;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        "phone": this.phone,
        "email": this.email,
        "verificationCode": this.verificationCode,
        "person": this.person.toJson(),
        "driver": this.driver != null ? this.driver.toJson() : null
      };
  User.fromJson(Map<String, dynamic> json)
      : _id = json["objectId"],
        _phone = json["phone"],
        _email = json["email"],
        _verificationCode = json["verificationCode"],
        sessionToken = json["sessionToken"],
        password = json["password"],
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
