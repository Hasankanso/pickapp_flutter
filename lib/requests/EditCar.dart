import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/requests/Request.dart';

class EditCar extends Request<List<Car>> {
  Car _car;

  EditCar(this._car) {
    httpPath = "/CarBusiness/UpdateCar";
  }

  @override
  List<Car> buildObject(json) {
    return json != null
        ? List<Car>.from(json.map((x) => Car.fromJson(x)))
        : null;
  }

  @override
  Map<String, dynamic> getJson() {
    var carJ = _car.toJson();
    carJ["user"] = App.user.id;
    return carJ;
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
