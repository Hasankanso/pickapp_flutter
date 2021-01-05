import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/requests/Request.dart';

class BecomeDriverRequest extends Request<Driver> {
  Driver _driver;

  BecomeDriverRequest(this._driver) {
    httpPath = "/DriverBusiness/BecomeDriver";
  }

  @override
  Driver buildObject(json) {
    return Driver.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var driverJ = _driver.toJson();
    driverJ["user"] = App.user.id;
    return driverJ;
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    if (App.calculateAge(App.person.birthday) < 18) {
      return "You can't be driver since you are under 18 years old";
    }
    return null;
  }
}
