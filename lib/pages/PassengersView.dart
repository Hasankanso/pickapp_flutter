import 'package:flutter/widgets.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/items/PassengerTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class PassengersView extends StatelessWidget {
  List<Reservation> passengers;

  PassengersView(this.passengers);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: ListBuilder(list: passengers, itemBuilder: PassengerTile.itemBuilder(passengers)),
    );
  }
}
