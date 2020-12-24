import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/requests/ReserveSeat.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
            SlidingUpPanel(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.0),
                  topRight: Radius.circular(18.0)),
              panel: Column(children: [
                ResponsiveWidget.fullWidth(
                  height: 80,
                  child: Column(children: [
                    VerticalSpacer(height: 10),
                    ResponsiveWidget(
                      width: 270,
                      height: 50,
                      child: MainButton(
                        text_key: "Reserve",
                        onPressed: () {
                          print("reserve");
                          ReserveSeat(ride, App.user, seats, seats)
                              .send(response);
                        },
                        isRequest: true,
                      ),
                    ),
                  ]),
                ),
                VerticalSpacer(height: 10),
                _Title(text: Lang.getString(context, "Description")),
                Text(ride.comment),
                VerticalSpacer(height: 30),
                _Title(text: Lang.getString(context, "Details")),
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
                Row(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Title(text: Lang.getString(context, "Date")),
                        _Title(
                            text: Lang.getString(context, "Available_Seats")),
                        _Title(text: Lang.getString(context, "Luggage")),
                        _Title(text: Lang.getString(context, "Stop_Duration")),
                        _Title(text: Lang.getString(context, "Price")),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          DateFormat(App.dateFormat).format(ride.leavingDate),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                        Text(ride.availableSeats.toString(),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,),
                        Text(ride.availableLuggages.toString(),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,),
                        Text(ride.stopTime.toString(),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,),
                        Text(ride.price.toString() +
                            ride.countryInformations.unit,
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,),
                      ],
                    ),
                  ],
                ),
              ]),
              body: Center(
                child: GridTile(
                  child: FittedBox(
                    fit: BoxFit.cover,
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
            Profile(),
            SingleChildScrollView(child: CarView(car: ride.car)),
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

class _Title extends StatelessWidget {
  String text;

  _Title({this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ResponsiveSpacer(
          width: 10,
        ),
        Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: Styles.labelTextStyle(bold: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.clip,
            )),
      ],
    );
  }
}
