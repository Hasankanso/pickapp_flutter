import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Request.dart';

class DeleteCar extends Request<List<Car>> {
  Car _car;
  User _user;

  DeleteCar(this._car, this._user) {
    httpPath = "/CarBusiness/DeleteCar";
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
    List<Ride> rides = App.person.upcomingRides;
    for (var item in rides) {
      if (item.car.id == _car.id) {
        return "You have an upcoming ride in this car";
      }
    }
    if (Validation.isNullOrEmpty(_car.id)) {
      return "Car should not be null";
    }
    return null;
  }
}
