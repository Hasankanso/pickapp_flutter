import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Ride.dart';
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
  Ride r1 = new Ride.name("Nabatieh", "Beirut", "5000 LBP", 5, 4);
  Ride r2 = new Ride.name("Saida", "Tripoli", "15000 LBP", 4, 6);
  Ride r3 = new Ride.name("Tripoli", "Beirut", "9000 LBP", 1, 2);
  Ride r4 = new Ride.name("Tyre", "Saida", "3000 LBP", 4, 2);
  @override
  Widget build(BuildContext context) {
    ridesList.add(r1);
    ridesList.add(r2);
    ridesList.add(r3);
    ridesList.add(r4);


    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "My_Rides"),
      ),
      body: Container(
        child:ListBuilder(ridesList,MyRidesListTile.MyRidesListTileBuilder(ridesList)),
      ),
    );
  }
}
