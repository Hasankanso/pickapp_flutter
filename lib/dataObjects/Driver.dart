import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';

class Driver {
  String _id;
  List<MainLocation> _regions = new List<MainLocation>();
  List<Car> _cars;
  DateTime _updated;

  Driver({
    String id,
    List<Car> cars,
    List<MainLocation> regions,
    DateTime updated,
  }) {
    this.id = id;
    this.regions = regions;
    this.cars = cars;
    this.updated = updated;
  }
  Map<String, dynamic> toJson() => <String, dynamic>{
        "regions": List<dynamic>.from(regions.map((x) => x.toJson())),
        "cars": List<dynamic>.from(cars.map((x) => x.toJson())),
      };

  factory Driver.fromJson(Map<String, dynamic> json) {
    var regions = List<MainLocation>(3);
    var reg1 = json["region1"];
    MainLocation regL1 = null;
    if (reg1 != null) {
      regL1 = MainLocation.fromJson(reg1);
      regions.add(regL1);
    }

    var reg2 = json["region2"];
    MainLocation regL2 = null;
    if (reg2 != null) {
      regL2 = MainLocation.fromJson(reg2);
      regions.add(regL2);
    }

    var reg3 = json["region3"];
    MainLocation regL3 = null;
    if (reg3 != null) {
      regL3 = MainLocation.fromJson(reg3);
      regions.add(regL3);
    }

    return Driver(
      id: json["objectId"],
      cars: json["cars"] != null
          ? List<Car>.from(json["cars"].map((x) => Car.fromJson(x)))
          : null,
      regions: regions,
    );
  }

  @override
  String toString() {
    return 'Driver{_id: $_id, _regions: $_regions, _cars: $_cars, _updated: $_updated}';
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  bool Equals(Object d) {
    return id == (d as Driver).id;
  }

  List<MainLocation> get regions => _regions;

  set regions(List<MainLocation> value) {
    _regions = value;
  }

  List<Car> get cars => _cars;

  set cars(List<Car> value) {
    _cars = value;
  }

  DateTime get updated => _updated;

  set updated(DateTime value) {
    _updated = value;
  }
}
