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
    return _driver.toJson();
  }

  @override
  String isValid() {
    return null;
  }
}
