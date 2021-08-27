import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/requests/Request.dart';

class AddCar extends Request<Car> {
  Car _car;

  AddCar(this._car) {
    httpPath = "/CarBusiness/AddCar";
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
