import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/CarDetails.dart';
import 'package:pickapp/requests/ReserveSeat.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';


class RideDetails extends StatelessWidget {
  final Ride ride;
  int seats = 1;

  RideDetails({this.ride});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: MainScaffold(
        appBar: MainAppBar(
          title: "Ride Details",
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map, size : Styles.smallIconSize())),
              Tab(icon: Icon(Icons.person, size : Styles.smallIconSize())),
              Tab(icon: Icon(Icons.directions_car, size : Styles.smallIconSize())),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Text(ride.from.name + " to " + ride.to.name),
                ResponsiveWidget(
                  height: 80,
                  width: 260,
                  child: MainButton(
                    text_key: "Reserve",
                    onPressed: () {
                      print("reserve");
                      ReserveSeat(ride, App.user, seats, seats).send(response);
                    },
                    isRequest: true,
                  ),
                ),
              ],
            ),
            CarDetails(car : ride.car),
            CarDetails(car : ride.car),
          ],
        ),
      ),
    );
  }

  response(Ride r, int status, String reason) {
    if (status == 200) {
      print("ride " + ride.id + " ");
    } else {
      print("SMTH WRONG RESERVE SEAT");
    }
  }
}
