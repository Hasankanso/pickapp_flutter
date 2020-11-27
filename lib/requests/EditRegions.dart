import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class EditRegions extends Request<Driver> {
  Driver _driver;
  User _user;

  EditRegions(this._driver, this._user) {
    httpPath = "/DriverBusiness/EditRegions";
  }

  @override
  Driver buildObject(json) {
    return Driver.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'regions': List<dynamic>.from(_driver.regions.map((x) => x.toJson())),
      'user': _user.id
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(_user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
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
    return null;
  }
}
