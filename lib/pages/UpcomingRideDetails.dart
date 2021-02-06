import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/PassengersView.dart';
import 'package:pickapp/pages/RideView.dart';
import 'package:pickapp/utilities/MainAppBar.dart';

class UpcomingRideDetails extends StatelessWidget {
  final Ride ride;
  String buttonText;
  void Function(Ride) onPressed;
  UpcomingRideDetails(this.ride, {this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MainAppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: Styles.largeIconSize(),
                ),
                tooltip: Lang.getString(context, "Delete"),
                onPressed: (){})
          ],
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
