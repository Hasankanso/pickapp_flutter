import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/DataObjects/Car.dart';

class Driver {
  String _id;
  List<Location> _regions = new List<Location>();
  List<Car> _cars;
  DateTime _updated;

  Driver({
    id,
    cars,
    regions,
    updated,
  }) {
    this.id = id;
    this.regions = regions;
    this.cars = cars;
    this.updated = updated;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  bool Equals(Object d) {
    return id == (d as Driver).id;
  }

  List<Location> get regions => _regions;

  set regions(List<Location> value) {
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
/*
Map<String, dynamic> toJson()
{
  return <String, dynamic>{

  foreach (Location r in regions)
  {
    //JObject regionJ = new JObject();
    //regionJ["Region"] = r;
    regionsArray.Add(r);
  }
  driverJ[nameof(regions)] = regionsArray;
  foreach (Car c in cars)
  {
    carsArray.Add(c.ToJson());
  }
  driverJ[nameof(cars)] = carsArray;
  /*foreach (ScheduleRide s in schedules)
        {
            schedulesArray.Add(s.ToJson());
        }
        driverJ[nameof(schedules)] = schedulesArray;*/
  return driverJ;
}

public static Driver ToObject(JObject driver)
{
  string did = "";
  var dId = driver["objectId"];
  if (dId != null) did = dId.ToString();
  JArray carsJ = (JArray)driver.GetValue("cars");
  List<Car> cars = null;

  //List<ScheduleRide> schedules = new List<ScheduleRide>();
  List<Location> regions = new List<Location>(3);

  if (carsJ != null)
  {
    cars = new List<Car>();
    foreach (var car in carsJ)
    {
      cars.Add(Car.ToObject((JObject)car));
    }
  }

  var reg1 = driver["region1"];
  Location regL1 = null;
  if (reg1 != null && reg1.HasValues)
  {
    regL1 = Location.ToObject((JObject)reg1);
    regions.Add(regL1);
  }

  var reg2 = driver["region2"];
  Location regL2 = null;
  if (reg2 != null && reg2.HasValues)
  {
    regL2 = Location.ToObject((JObject)reg2);
    regions.Add(regL2);
  }

  var reg3 = driver["region3"];
  Location regL3 = null;
  if (reg3 != null && reg3.HasValues)
  {
    regL3 = Location.ToObject((JObject)reg3);
    regions.Add(regL3);
  }

  /* if (driver.GetValue("schedules") != null && !string.IsNullOrEmpty(driver.GetValue("schedules").ToString()) && !driver.GetValue("schedules").ToString().Equals("[]"))
        {
            JArray schedulesJ = (JArray)driver.GetValue("schedules");

            foreach (var schedule in schedulesJ)
            {
                schedules.Add(ScheduleRide.ToObject((JObject)schedule));
            }
        }*/

  return new Driver(did, cars,/* schedules,*/ regions);
}
*/
}
