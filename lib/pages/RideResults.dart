import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pickapp/Items/RideResultListTile.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class RideResults extends StatefulWidget {
  @override
  _RideResultsState createState() => _RideResultsState();
}

class _RideResultsState extends State<RideResults> {
  final List<Ride> ridesList = new List();

  @override
  Widget build(BuildContext context) {
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    ridesList.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));

    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Rides"),
      ),
      body: Container(
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: ridesList.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 100.0,
                  child: FadeInAnimation(
                    child: RideResultListTile(ridesList[index]),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
