import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/CarDetails.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/requests/ReserveSeat.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

import 'CarView.dart';


class RideDetails extends StatelessWidget {
  final Ride ride;
  int seats = 1;

  RideDetails({this.ride});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MainAppBar(
          title: Lang.getString(context,  "Ride_Details"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map, size : Styles.mediumIconSize())),
              Tab(icon: Icon(Icons.person, size : Styles.mediumIconSize())),
              Tab(icon: Icon(Icons.directions_car, size : Styles.mediumIconSize())),
            ],
          ),
        ),
        body: TabBarView(

          children: [
            Column(
              children: [
                ResponsiveWidget.fullWidth(
                  height: 300,
                  child: GridTile(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: CachedNetworkImage(
                        imageUrl: ride.mapUrl?? "",
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                        ),
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Styles.secondaryColor(),
                          child: Spinner(),
                        ),
                        errorWidget: (context, url, error) {
                          return Image(
                            image: AssetImage("lib/images/map.jpg"),
                          );
                        },
                      ),
                    ),
                    footer: Container(
                      height: ScreenUtil().setHeight(40),
                      color: Colors.black.withOpacity(0.3),
                      alignment: Alignment.center,
                      child: Text(
                          ride.from.name + " to " + ride.to.name,
                        style: Styles.titleTextStyle(),
                      ),
                    ),
                  ),
                ),
                VerticalSpacer(height: 30,),
                ResponsiveWidget(
                  height: 70,
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
            Profile(),
            CarView(car : ride.car),
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
