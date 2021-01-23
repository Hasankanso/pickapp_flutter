import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/PassengersView.dart';
import 'package:pickapp/pages/RideView.dart';
import 'package:pickapp/utilities/MainAppBar.dart';

class RideDetails2 extends StatelessWidget {
  final Ride ride;
  String buttonText;
  void Function(Ride) onPressed;
  RideDetails2(this.ride, {this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Ride_Details"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map, size: Styles.mediumIconSize())),
              Tab(
                  icon: Icon(Icons.airline_seat_recline_extra_sharp,
                      size: Styles.mediumIconSize())),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            RideView(ride, buttonText: buttonText, onPressed: onPressed),
            ride.passengers!=null
                ?PassengersView(ride.passengers)
                :Center(child: Text("No passengers yet !!"))
          ],
        ),
      ),
    );
  }
}
