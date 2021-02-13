import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/DriverView.dart';
import 'package:pickapp/pages/RideView.dart';
import 'package:pickapp/utilities/MainAppBar.dart';

import 'CarView.dart';

class RideDetails extends StatelessWidget {
  final Ride ride;
  String buttonText;
  void Function(Ride) onPressed;

  RideDetails(this.ride, {this.buttonText, this.onPressed});
  void handleClick(String value) {
    switch (value) {
      case 'Cancel Reservation':
        print("hii");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Ride_Details"),
          actions: [
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "Cancel Reservation",
                    child: Text(
                      Lang.getString(context, "Cancel_Reservation"),
                      style: Styles.valueTextStyle(),
                    ),
                  ),
                ];
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map, size: Styles.mediumIconSize())),
              Tab(icon: Icon(Icons.person, size: Styles.mediumIconSize())),
              Tab(
                  icon: Icon(Icons.directions_car,
                      size: Styles.mediumIconSize())),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            RideView(ride, buttonText: buttonText, onPressed: onPressed),
            DriverView(user: ride.user),
            CarView(car: ride.car),
          ],
        ),
      ),
    );
  }
}
