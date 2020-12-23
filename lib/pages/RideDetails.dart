import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            SingleChildScrollView(
              child: Column(
                children: [
                  ResponsiveWidget(
                    width: 300,
                    height: 250,
                    child: Card(
                      elevation: 10,
                      child: GridTile(
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: CachedNetworkImage(
                            imageUrl: ride.mapUrl ?? "",
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
                  ),
                  VerticalSpacer(height: 10),
                  _Title(text : "Description"),
                  Text(ride.comment),
                  VerticalSpacer(height: 30),
                  _Title(text : "Details"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.pets,
                        color: ride.petsAllowed
                            ? Styles.primaryColor()
                            : Styles.labelColor(),
                      ),
                      Icon(
                        ride.smokingAllowed
                            ? Icons.smoking_rooms
                            : Icons.smoke_free,
                        color: ride.smokingAllowed
                            ? Styles.primaryColor()
                            : Styles.labelColor(),
                      ),
                      Icon(
                        Icons.ac_unit,
                        color: ride.acAllowed
                            ? Styles.primaryColor()
                            : Styles.labelColor(),
                      ),
                      Icon(
                        ride.musicAllowed ? Icons.music_note : Icons.music_off,
                        color: ride.musicAllowed
                            ? Styles.primaryColor()
                            : Styles.labelColor(),
                      ),
                    ],
                  ),
                  VerticalSpacer(height: 30),

                  Row(
                    children: [
                      Spacer(),
                      Expanded(flex: 6, child: _Title(text : "Date")),
                      Spacer(flex : 6),
                      Expanded(flex : 20, child: Text(DateFormat(App.dateFormat).format(ride.leavingDate), maxLines: 1,)),
                      Spacer(),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(flex : 1),
                      Expanded(flex: 20, child: _Title(text : "available Seats")),
                      Spacer(flex : 6),
                      Expanded(flex : 6, child: Text(ride.availableSeats.toString())),
                      Spacer(flex : 3),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(flex : 1),
                      Expanded(flex: 20, child: _Title(text : "available Luggage")),
                      Spacer(flex : 6),
                      Expanded(flex : 6, child: Text(ride.availableLuggages.toString())),
                      Spacer(flex : 3),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(flex : 1),
                      Expanded(flex: 20, child: _Title(text : "stop Time")),
                      Spacer(flex : 6),
                      Expanded(flex : 6, child: Text(ride.stopTime.toString())),
                      Spacer(flex : 3),
                    ],
                  ),
                  Row(
                    children: [
                      Spacer(flex : 1),
                      Expanded(flex: 20, child: _Title(text : "price")),
                      Spacer(flex : 6),
                      Expanded(flex : 6, child: Text(ride.price.toString() + ride.countryInformations.unit)),
                      Spacer(flex : 3),
                    ],
                  ),
                ],
              ),
            ),
            Profile(),
            SingleChildScrollView(child: CarView(car: ride.car)),
          ],
        ),
        bottomNavigationBar: ResponsiveWidget.fullWidth(
          height: 80,
          child: Column(children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Reserve",
                onPressed: () {
                  print("reserve");
                  ReserveSeat(ride, App.user, seats, seats).send(response);
                },
                isRequest: true,
              ),
            ),
          ]),
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

class _Title extends StatelessWidget {
  String text;

  _Title({this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: Styles.valueTextStyle(bold: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.clip,
        ));
  }
}
