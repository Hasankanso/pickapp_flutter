import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/MyRidesHistoryTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class MyRidesHistory extends StatelessWidget {
  List<Ride> ridesList = List<Ride>();

  @override
  Widget build(BuildContext context) {
    ridesList = App.user.person.upcomingRides;

    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "My_Rides_History"),
        ),
        body: Container(
          child: App.user.person.upcomingRides.length > 0
              ? ListBuilder(
                  list: ridesList,
                  itemBuilder: MyRidesHistoryTile.itemBuilder(ridesList))
              : Center(
                  child: Text(Lang.getString(context, "No_Rides_History!"),
                      style: Styles.valueTextStyle())),
        ));
  }
}
