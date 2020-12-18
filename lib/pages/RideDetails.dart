import 'package:flutter/material.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class RideDetails extends StatelessWidget {

  final Ride ride;

  RideDetails({this.ride});

  @override
  Widget build(BuildContext context) {

    return MainScaffold(appBar : MainAppBar(title: "Ride Details"), body: Text(ride.from.name + " to " + ride.to.name), );

  }
}
