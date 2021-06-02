import 'package:flutter/widgets.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/items/PassengerTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

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
          itemBuilder: PassengerTile.itemBuilder(widget.allPassengers)),
    );
  }
}
