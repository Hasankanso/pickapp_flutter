import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class GetLoggedInUser extends Request<Person> {
  User _returningUser;

  GetLoggedInUser(this._returningUser) {
    httpPath = "/UserBusiness/GetLoggedInUser";
  }

  @override
  Person buildObject(json) {
    Person u = Person.fromJson(json["person"]);
    //todo cache
    //Cache.SetEmail(json["email"].ToString());
    String userStatus = json["userStatus"].ToString();
    App.user.userStatus = userStatus;
    Driver driver = null;
    var driverJ = json["driver"];
    if (driverJ != null) {
      driver = Driver.fromJson(driverJ);
      App.user.driver = driver;
    }
    return u;
  }

  @override
  Map<String, dynamic> getJson() {
    return <String, dynamic>{
      'id': _returningUser.id,
    };
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(_returningUser);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    return null;
  }
}
