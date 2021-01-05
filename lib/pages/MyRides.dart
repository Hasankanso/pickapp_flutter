import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/MyRidesTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  List<Ride> ridesList = List<Ride>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (App.user != null) ridesList = App.user.person.upcomingRides;
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "My_Rides"),
      ),
      body: Container(
        child: ridesList.length > 0
            ? ListBuilder(
                list: ridesList,
                itemBuilder: MyRidesTile.itemBuilder(ridesList, () {
                  print("hello");
                }))
            : Center(
                child: Text("No Upcoming rides !",
                    style: Styles.valueTextStyle())),
      ),
    );
  }
}
