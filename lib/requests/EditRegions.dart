import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/requests/Request.dart';

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
      'regions': List<dynamic>.from(_driver.regions.map((x) => x.toJson()))
    };
  }
}
