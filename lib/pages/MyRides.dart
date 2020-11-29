import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/MyRidesListTile.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  final List<Ride> ridesList = new List();
  //Ride r1 = new Ride("Nabatieh", "Beirut", "5000 LBP", 5, 4);
  //Ride r2 = new Ride("Saida", "Tripoli", "15000 LBP", 4, 6);
  // Ride r3 = new Ride(from:"Tripoli",to: "Beirut", "9000 LBP", 1, 2);
  //Ride r4 = new Ride("Tyre", "Saida", "3000 LBP", 4, 2);

  @override
  Widget build(BuildContext context) {
    if (!App.isLoggedIn) {
      return Login();
    }
    //ridesList.add(r1);
    // ridesList.add(r2);
    // ridesList.add(r3);
    //ridesList.add(r4);
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "My_Rides"),
      ),
      body: Container(
        child: ListBuilder(
            list: ridesList,
            itemBuilder: MyRidesListTile.itemBuilder(ridesList)
        ),
      ),
    );
  }
}
