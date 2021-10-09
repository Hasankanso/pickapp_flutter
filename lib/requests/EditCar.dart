import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/requests/Request.dart';

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
}
