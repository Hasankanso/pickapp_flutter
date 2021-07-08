import 'dart:math';

import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/AddRide.dart';
import 'package:pickapp/requests/Request.dart';

class FakeRequests {
  static int ridesCount = 20;

  static void response(Ride p1, int statusCode, String p3) {
    if (statusCode == 200) {
      App.user.person.upcomingRides.add(p1);
    }
  }

  static Future<void> addRides() async {
    {
      MainLocation Dekwene = MainLocation(
        placeId: "ChIJpYsqg0oWHxURju7gIgVyRYk",
        name: "Dekwaneh, Lebanon",
        latitude: 33.8793878,
        longitude: 35.543721,
      );

      MainLocation Saida = MainLocation(
        placeId: "ChIJpYsqg0oWHxURju7gIgVyRYk",
        name: "Dekwaneh, Lebanon",
        latitude: 33.8793878,
        longitude: 35.543721,
      );

      MainLocation Doueir = MainLocation(
        placeId: "ChIJFa0T-umSHhURji8QSkA9DeM",
        name: "Doueir, Lebanon",
        latitude: 33.3901493,
        longitude: 35.4183324,
      );

      MainLocation Beirut = MainLocation(
        placeId: "ChIJj6eAWCEXHxURtDaY6bqCkXI",
        name: "Beirut, Lebanon",
        latitude: 33.8937913,
        longitude: 35.5017767,
      );

      MainLocation Tyre = MainLocation(
        placeId: "ChIJlV2RL5B9HhURCHSZ-8Y_Ds8",
        name: "Tyre, Lebanon",
        latitude: 33.2704888,
        longitude: 35.2037641,
      );

      MainLocation Tripoli = MainLocation(
        placeId: "ChIJM524nav2IRUReIXefVJSPDI",
        name: "Tripoli, Lebanon",
        latitude: 33.4345947,
        longitude: 35.8361633,
      );

      DateTime now = new DateTime.now();
      List<Ride> rides = <Ride>[];
      Random ranGen = Random();

      for (int i = 0; i < ridesCount; i++) {
        int day = ranGen.nextInt(7);
        int hours = ranGen.nextInt(24);
        int month = ranGen.nextInt(56);
        int price = 1000 + ranGen.nextInt(100001); // min 1000
        int maxSeats = 3 + ranGen.nextInt(4); //min 3, max 3 + 3 = 6
        int maxLuggage = 3 + ranGen.nextInt(3); // min 3, max 3 + 2 = 5
        bool music = ranGen.nextBool();
        bool pets = ranGen.nextBool();
        bool smoking = ranGen.nextBool();
        bool ac = ranGen.nextBool();
        bool kidSeat = ranGen.nextBool();
        int stopTime = ranGen.nextInt(31);

        List<MainLocation> locations = [Dekwene, Saida, Doueir, Beirut, Tyre, Tripoli];

        int fromIndex = ranGen.nextInt(locations.length);
        MainLocation from = locations[fromIndex];
        locations.removeAt(fromIndex);
        MainLocation to = locations[ranGen.nextInt(locations.length)];

        assert(App.driver != null, "become a driver before adding fake rides");
        List<Car> cars = App.driver.cars;
        Car car = cars[ranGen.nextInt(cars.length)];

        Ride ride = Ride(
          from: from,
          to: to,
          leavingDate: now.add(Duration(days: day, hours: hours, minutes: month)),
          maxSeats: maxSeats,
          price: price,
          maxLuggage: maxLuggage,
          availableSeats: maxSeats,
          availableLuggage: maxLuggage,
          musicAllowed: music,
          petsAllowed: pets,
          smokingAllowed: smoking,
          acAllowed: ac,
          stopTime: stopTime,
          mapBase64:
              "iVBORw0KGgoAAAANSUhEUgAAAoAAAAKACAMAAAA7EzkRAAAC/VBMVEU/QnxLS0tPU1tcW1tDRnVbX2NkY2NjZ29qamlvcnZ0dHNydX07PoQsLqMyNKk2ObA9P7RDRbpNT7FKTL9xdYt6foJ0eJplaL98f75OUMVVV8pZW9BdYM5oaspgYtVmZ9psbN9zdNVxcuVzdeh9few0qFNChPNEiPJPjPNYk/RklOViluttnvR/q/KaazjqQzXpTD7qTUDqXlHrem6Gdb2IdbKKe7yUf6uFec6Dfd+AfvD7vAX4yj/5y0npyHr41XKDgoKGioqLioqOkpaVlZSYmJeanZ2FiKuPgbybhaeYgqmTgbaRg7uXiLmYhbScjbeanq6rk52wl5u5n5",
          comment: "This is a fake Ride, just for testing, thank you",
          kidSeat: kidSeat,
          user: App.user,
          car: car,
        );

        Request<Ride> addRide = AddRide(ride);
        await addRide.send(response);
      }
    }
  }
}
