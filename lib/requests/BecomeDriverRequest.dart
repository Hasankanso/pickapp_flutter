import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class BecomeDriverRequest extends Request<Driver> {
  Driver _driver;
  User _user;

  BecomeDriverRequest(this._driver, this._user) {
    httpPath = "/DriverBusiness/BecomeDriver";
  }

  @override
  Driver buildObject(json) {
    return Driver.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var driverJ = _driver.toJson();
    driverJ["user"] = _user.id;
    return driverJ;
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (App.calculateAge(_user.person.birthday) < 18) {
      return "You can't be driver since you are under 18 years old";
    }
    if (_driver.regions[0] == null) {
      return "You should add at least 1 region";
    }
    if (_driver.regions.length == 2) {
      if (_driver.regions[0].latitude == _driver.regions[1].latitude &&
          _driver.regions[0].longitude == _driver.regions[1].longitude) {
        return "Regions can't be dublicated";
      }
    }
    if (_driver.regions.length == 3) {
      if (_driver.regions[0].latitude == _driver.regions[2].latitude &&
          _driver.regions[0].longitude == _driver.regions[2].longitude) {
        return "Regions can't be dublicated";
      }
      if (_driver.regions[1].latitude == _driver.regions[2].latitude &&
          _driver.regions[1].longitude == _driver.regions[2].longitude) {
        return "Regions can't be dublicated";
      }
    }
    if (_driver.regions.length > 3) {
      return "You can't add more than 3 regions";
    }
    if (_driver.cars[0] != null) {
      return Car.validate(_driver.cars[0]);
    }
    return null;
  }
}
