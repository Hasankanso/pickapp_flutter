import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/RideRoute.dart';
import 'package:pickapp/requests/AddRide.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/RouteTile.dart';

class AddRidePage4 extends StatefulWidget {
  final Ride rideInfo;

  const AddRidePage4({Key key, this.rideInfo}) : super(key: key);

  @override
  _AddRidePage4State createState() => _AddRidePage4State(rideInfo);
}

class _AddRidePage4State extends State<AddRidePage4> {
  final Ride rideInfo;
  final List<RideRoute> rideRoutes = new List();

  RideRoute r1 = new RideRoute("Tyre-Beirut");

  RideRoute r2 = new RideRoute("Tyre-Saida");

  RideRoute r3 = new RideRoute("Saida-Tripoli");

  RideRoute r4 = new RideRoute("Bent Jbeil-Beirut");

  _AddRidePage4State(this.rideInfo);
  response(Ride result, int code, String message) {
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    rideRoutes.add(r1);
    rideRoutes.add(r2);
    rideRoutes.add(r3);

    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 40,
              child: ResponsiveRow(
                children: [
                  Text(
                    Lang.getString(
                            context, "Choose_A_Route_From_The_List_Below") +
                        " :",
                    style: Styles.labelTextStyle(),
                  )
                ],
              ),
            ),
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 220,
              child: Container(
                color: Colors.grey[100],
                child: ListBuilder(
                    list: rideRoutes,
                    itemBuilder: RouteTile.itemBuilder(rideRoutes)),
              ),
            ),
            ResponsiveWidget(
              width: 250,
              height: 250,
              child: Image(
                image: AssetImage("lib/images/map.jpg"),
              ),
            ),
            VerticalSpacer(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveWidget(
        width: 270,
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "DONE",
                onPressed: () {
                  String routeId = "";
                  rideInfo.setMap(null) ;
                  Request<Ride> request=AddRide(rideInfo);
                  request.send(response);
                  Navigator.of(context).pushNamed("/");
                  CustomToast().showShortToast(
                      Lang.getString(context, "Ride_Added"),
                      backgroundColor : Colors.greenAccent);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
