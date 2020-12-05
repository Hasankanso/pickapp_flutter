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
  @override
  Widget build(BuildContext context) {
    if (!App.isLoggedIn) {
      return Login();
    }
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "My_Rides"),
      ),
      body: Container(
        child: ListBuilder(
            list: ridesList,
            itemBuilder: MyRidesListTile.itemBuilder(ridesList)),
      ),
    );
  }
}
