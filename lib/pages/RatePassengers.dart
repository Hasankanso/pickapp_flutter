import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/PassengerRateTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class RatePassengers extends StatelessWidget {
  final Ride ride;

  const RatePassengers({Key key, this.ride}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Review_Passengers"),
      ),
      body: ride.passengers.isEmpty
          ? Center(child: Text("No Passengers"))
          : ListBuilder(
              list: ride.passengers,
              itemBuilder: PassengerRateTile.createPassengersItems(ride.passengers)),
    );
  }
}
