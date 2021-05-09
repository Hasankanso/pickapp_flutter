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
  List<Reservation> reservedPassengers;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reservedPassengers = <Reservation>[];
    for (int i = 0; i < widget.allPassengers.length; i++) {
      if (widget.allPassengers[i].status != "CANCELED")
        reservedPassengers.add(widget.allPassengers[i]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: ListBuilder(
          list: reservedPassengers,
          itemBuilder: PassengerTile.itemBuilder(reservedPassengers)),
    );
  }
}
