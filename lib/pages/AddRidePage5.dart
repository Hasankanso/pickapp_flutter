import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/requests/AddRide.dart';

class AddRidePage5 extends StatefulWidget {
  final Ride rideInfo;

  const AddRidePage5({Key key, this.rideInfo}) : super(key: key);

  @override
  _AddRidePage5State createState() => _AddRidePage5State(rideInfo);
}

class _AddRidePage5State extends State<AddRidePage5> {
  final Ride ride;

  _AddRidePage5State(this.ride);

  response(Ride result, int code, String message) {
    App.user.person.upcomingRides.add(result);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _Title(text: Lang.getString(context, "From")),
                      _Title(text: Lang.getString(context, "To")),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _Value(
                        text: ride.from.name,
                        maxlines: 1,
                      ),
                      _Value(
                        text: ride.to.name,
                        maxlines: 1,
                      ),
                    ],
                  ),
                )
              ],
            ),
            VerticalSpacer(height: 20),
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
            VerticalSpacer(height: 20),
            Row(
              children: [
                Expanded(
                  flex:2,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Title(text: Lang.getString(context, "Date")),
                      _Title(text: Lang.getString(context, "Car")),
                      _Title(text: Lang.getString(context, "Available_Seats")),
                      _Title(text: Lang.getString(context, "Luggage")),
                      _Title(text: Lang.getString(context, "Kid's_Seat")),
                      _Title(text: Lang.getString(context, "Stop_Duration")),
                      _Title(text: Lang.getString(context, "Price")),
                    ],
                  ),
                ),
                Expanded(
                  flex:3,

                  child: Column(
                    children: [
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: Text(
                          DateFormat(App.dateFormat).format(ride.leavingDate),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: Text(ride.car.brand.toString()+" "+ride.car.name.toString(),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: Text(
                          ride.availableSeats.toString(),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: Text(
                          ride.availableLuggages.toString(),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: ride.kidSeat==true?Text("1",
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ):
                        Text("0",
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        )
                        ,
                      ),
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: Text(
                          ride.stopTime == null
                              ? "0 " +
                              Lang.getString(context, "Min")
                              : ride.stopTime.toString() +
                                  " " +
                                  Lang.getString(context, "Min"),
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      ResponsiveWidget.fullWidth(
                        height: 40,
                        child: Text(
                          ride.price.toString() +
                              " " +ride.countryInformations.unit,
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 20),
            _Title(text: Lang.getString(context, "Description")),
            ResponsiveRow(
              children: [
                _Value(
                  text: ride.comment,
                  maxlines: 3,
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveWidget(
        width: 270,
        height: 100,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: true,
                text_key: "Done",
                onPressed: () async {
                  Request<Ride> request = AddRide(ride);
                  await request.send(response);
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (Route<dynamic> route) => false);

                  CustomToast().showSuccessToast(
                      Lang.getString(context, "Successfully_added!"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  String text;

  _Title({this.text});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 40,
      child: Row(
        children: [
          ResponsiveSpacer(
            width: 15,
          ),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: Styles.labelTextStyle(bold: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.clip,
              )),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  String text;
  int maxlines;

  _Value({this.text, this.maxlines});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 40,
      child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: Styles.valueTextStyle(),
            maxLines: maxlines,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}
