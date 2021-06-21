import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/requests/Request.dart';

class EditCar extends Request<Car> {
  Car _car;

  EditCar(this._car) {
    httpPath = "/CarBusiness/UpdateCar";
  }

  @override
  Car buildObject(json) {
    return Car.fromJson(json);
  }

  @override
  Map<String, dynamic> getJson() {
    var carJ = _car.toJson();
    carJ["user"] = App.user.id;
    return carJ;
  }

  @override
  String isValid() {
    return null;
  }
}
