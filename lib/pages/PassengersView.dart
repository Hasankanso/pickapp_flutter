import 'package:flutter/widgets.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/items/PassengerTile.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainScaffold.dart';

class PassengersView extends StatefulWidget {
  List<Reservation> allPassengers;

  PassengersView(this.allPassengers);

  @override
  _PassengersViewState createState() => _PassengersViewState();
}

class _PassengersViewState extends State<PassengersView> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: ListBuilder(
        list: widget.allPassengers,
        itemBuilder: PassengerTile.itemBuilder(widget.allPassengers),
        nativeAdElevation: 3.0,
        nativeAdHeight: 90,
      ),
    );
  }
}
