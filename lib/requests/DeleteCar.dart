import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/requests/Request.dart';

class DeleteCar extends Request<Car> {
  Car _car;

  DeleteCar(this._car) {
    httpPath = "/CarBusiness/DeleteCar";
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
