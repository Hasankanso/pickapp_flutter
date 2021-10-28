import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_miles/ads/Ads.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/AddRide.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class AddRidePage5 extends StatefulWidget {
  final Ride rideInfo;
  final String appBarTitleKey;

  const AddRidePage5({Key key, this.rideInfo, this.appBarTitleKey}) : super(key: key);

  @override
  _AddRidePage5State createState() => _AddRidePage5State(rideInfo);
}

class _AddRidePage5State extends State<AddRidePage5> {
  final Ride ride;

  _AddRidePage5State(this.ride);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, widget.appBarTitleKey),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(
              height: 15,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                    flex: 5,
                    child: Container(child: _Title(text: Lang.getString(context, "From")))),
                Expanded(
                  flex: 20,
                  child: _Value(
                    text: ride.from.name,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            VerticalSpacer(
              height: 10,
            ),
            Row(
              children: [
                Spacer(),
                Expanded(
                  flex: 5,
                  child: _Title(text: Lang.getString(context, "To")),
                ),
                Expanded(
                  flex: 20,
                  child: _Value(
                    text: ride.to.name,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 40),
            Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(flex: 20, child: _Title(text: Lang.getString(context, "Details"))),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.pets,
                  color: ride.petsAllowed ? Styles.primaryColor() : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
                Icon(
                  ride.smokingAllowed ? Icons.smoking_rooms : Icons.smoke_free,
                  color: ride.smokingAllowed ? Styles.primaryColor() : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
                Icon(
                  Icons.ac_unit,
                  color: ride.acAllowed ? Styles.primaryColor() : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
                Icon(
                  ride.musicAllowed ? Icons.music_note : Icons.music_off,
                  color: ride.musicAllowed ? Styles.primaryColor() : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
              ],
            ),
            VerticalSpacer(height: 30),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Date")),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    DateFormat(App.dateFormat, Localizations.localeOf(context).toString())
                        .format(ride.leavingDate),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Car")),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    Lang.getString(context, ride.car.brand) + " " + ride.car.name.toString(),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(flex: 15, child: _Title(text: Lang.getString(context, "Available_Seats"))),
                Expanded(
                  flex: 22,
                  child: Text(
                    ride.availableSeats.toString(),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Luggage")),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    ride.availableLuggages.toString(),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Kids_Seat")),
                ),
                Expanded(
                    flex: 22,
                    child: Text(
                      ride.kidSeat == true ? "1" : "0",
                      maxLines: 1,
                      style: Styles.valueTextStyle(),
                      overflow: TextOverflow.clip,
                    )),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Stop_Duration")),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    (ride.stopTime == null ? "0" : ride.stopTime.toString()) +
                        " " +
                        Lang.getString(context, "Min"),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Price")),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    ride.price.toString() +
                        " " +
                        Lang.getString(context, ride.countryInformations.unit),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 40),
            Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(flex: 20, child: _Title(text: Lang.getString(context, "Description"))),
              ],
            ),
            VerticalSpacer(height: 10),
            ResponsiveRow(
              children: [
                _Value(
                  text: ride.comment,
                  maxLines: 9,
                ),
              ],
            ),
            VerticalSpacer(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: true,
                text_key: "Done",
                onPressed: () async {

                 await Ads.showRewardedAd(() async {
                  ride.mapUrl=await Request.uploadImage("name.png", VoomcarImageType.Map,
                        fileName: "name",fromBytes: true, bytes: ride.imageBytes);
                    Request<Ride> request = AddRide(ride);
                    await request.send((result, code, message) {
                      return _addRideResponse(result, code, message, context);
                    });
                });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_addRideResponse(Ride result, int code, String message, context) {
  if (code != HttpStatus.ok) {
    CustomToast().showErrorToast(message);
  } else {
    App.addRideToMyRides(result, context);

    Navigator.pushNamedAndRemoveUntil(context, "/", (Route<dynamic> route) => false);

    CustomToast().showSuccessToast(Lang.getString(context, "Successfully_added!"));
  }
}

class _Title extends StatelessWidget {
  final String text;

  _Title({this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          text,
          textAlign: TextAlign.start,
          style: Styles.labelTextStyle(bold: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.clip,
        ));
  }
}

class _Value extends StatelessWidget {
  final String text;
  final int maxLines;

  _Value({this.text, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: Styles.valueTextStyle(),
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
