import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/DriverView.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/RideView.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/ReserveSeat.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'CarView.dart';

class RideDetails extends StatelessWidget {
  final Ride ride;
  int seats = 1;
  int luggage = 1;

  RideDetails({this.ride});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Ride_Details"),
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
          children: [
            RideView(
                ride: ride,
                buttonTextKey: "Reserve",
                callback: onReservePressed),
            DriverView(user: ride.user),
            CarView(car: ride.car),
          ],
        ),
      ),
    );
  }

  void onReservePressed(Ride r) {
    ReserveSeat(r, App.user, seats, luggage).send(response);
  }

  response(Ride r, int status, String reason) {
    if (status == 200) {
      print("ride " + ride.id + " ");
    } else {
      print("SMTH WRONG RESERVE SEAT");
    }
  }
}
