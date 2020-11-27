import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class AddCar extends Request<List<Car>> {
  Car _car;
  User _user;

  AddCar(this._car, this._user) {
    httpPath = "/CarBusiness/AddCar";
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
    carJ["user"] = _user.id;
    return carJ;
  }

  @override
  String isValid() {
    String validateUser = Validation.validateLogin(_user);
    if (!Validation.isNullOrEmpty(validateUser)) {
      return validateUser;
    }
    return Car.validate(_car);
  }
}
