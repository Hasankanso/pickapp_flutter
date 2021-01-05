import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/requests/Request.dart';

class EditRegions extends Request<Driver> {
  Driver _driver;

  EditRegions(this._driver) {
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
      'user': App.user.id
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(App.user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    return null;
  }
}
