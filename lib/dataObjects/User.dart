import 'package:pickapp/DataObjects/Driver.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/DataObjects/Person.dart';

class User {
  String _id, _phone, _email, _verificationCode, _userStatus;
  Person _person;

  User({person, driver, phone, email, userStatus, id, verificationCode}) {
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
    // return string.Empty;
  }

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
  Driver _driver;

  Driver get driver => _driver;

  set driver(Driver value) {
    _driver = value;
  }

/* public JObject ToJson() {
    JObject userJ = new JObject();
    userJ[nameof(this.phone)] = this.phone;
    userJ[nameof(this.email)] = this.email;
    userJ[nameof(this.verificationCode)] = this.verificationCode;
    userJ[nameof(this.person)] = person.ToJson();
    return userJ;
  }*/
/*
  public static User ToObject(JObject json) {
    string userId = "";
    var uId = json["objectId"];
    if (uId != null)
      userId = uId.ToString();
    string phone = "";
    var ph = json[nameof(phone)];
    if (ph != null)
      phone = ph.ToString();
    string email = "";
    var em = json[nameof(email)];
    if (em != null)
      email = em.ToString();
    string userStatus = "";
    var status = json[nameof(userStatus)];
    if (status != null)
      userStatus = status.ToString();
    JObject driverJ = (JObject)json["driver"];
    JObject personJ = (JObject)json["person"];

    Person person = Person.ToObject(personJ);
    Driver driver = null;
    if (driverJ != null) {
      driver = Driver.ToObject(driverJ);
    }

    return new User(person, driver, phone, email, userId, userStatus);
  }
*/
}
