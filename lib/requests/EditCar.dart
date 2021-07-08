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
    return _car.toJson();
  }

  @override
  String isValid() {
    return null;
  }
}
