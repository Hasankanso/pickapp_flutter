import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/requests/Request.dart';

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
}
