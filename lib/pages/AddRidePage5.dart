import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/AddRide.dart';
import 'package:pickapp/requests/EditRide.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddRidePage5 extends StatefulWidget {
  final Ride rideInfo;
  final String appBarTitleKey;
  final bool isEditRide;

  const AddRidePage5(
      {Key key, this.rideInfo, this.appBarTitleKey, this.isEditRide = false})
      : super(key: key);

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
                    child: Container(
                        child: _Title(text: Lang.getString(context, "From")))),
                Expanded(
                  flex: 20,
                  child: _Value(
                    text: ride.from.name,
                    maxlines: 1,
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
                    maxlines: 1,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 20),
            Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 20,
                    child: _Title(text: Lang.getString(context, "Details"))),
              ],
            ),
            VerticalSpacer(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.pets,
                  color: ride.petsAllowed
                      ? Styles.primaryColor()
                      : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
                Icon(
                  ride.smokingAllowed ? Icons.smoking_rooms : Icons.smoke_free,
                  color: ride.smokingAllowed
                      ? Styles.primaryColor()
                      : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
                Icon(
                  Icons.ac_unit,
                  color: ride.acAllowed
                      ? Styles.primaryColor()
                      : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
                Icon(
                  ride.musicAllowed ? Icons.music_note : Icons.music_off,
                  color: ride.musicAllowed
                      ? Styles.primaryColor()
                      : Styles.labelColor(),
                  size: Styles.largeIconSize(),
                ),
              ],
            ),
            VerticalSpacer(height: 20),
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
                    DateFormat(App.dateFormat,
                            Localizations.localeOf(context).toString())
                        .format(ride.leavingDate),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 8),
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
                    ride.car.brand.toString() + " " + ride.car.name.toString(),
                    maxLines: 1,
                    style: Styles.valueTextStyle(),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
            VerticalSpacer(height: 8),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                    flex: 15,
                    child: _Title(
                        text: Lang.getString(context, "Available_Seats"))),
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
            VerticalSpacer(height: 8),
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
            VerticalSpacer(height: 8),
            Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  flex: 15,
                  child: _Title(text: Lang.getString(context, "Kid's_Seat")),
                ),
                Expanded(
                  flex: 22,
                  child: ride.kidSeat == true
                      ? Text(
                          "1",
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        )
                      : Text(
                          "0",
                          maxLines: 1,
                          style: Styles.valueTextStyle(),
                          overflow: TextOverflow.clip,
                        ),
                ),
              ],
            ),
            VerticalSpacer(height: 8),
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
            VerticalSpacer(height: 8),
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
            VerticalSpacer(height: 20),
            Row(
              children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 20,
                    child:
                        _Title(text: Lang.getString(context, "Description"))),
              ],
            ),
            VerticalSpacer(height: 10),
            ResponsiveRow(
              children: [
                _Value(
                  text: ride.comment,
                  maxlines: 9,
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
                  if (!widget.isEditRide) {
                    Request<Ride> request = AddRide(ride);
                    await request.send((result, code, message) =>
                        _addRideResponse(result, code, message, context));
                  } else {
                    Request<Ride> request = EditRide(ride);
                    await request.send((result, code, message) =>
                        _editRideResponse(result, code, message, context));
                  }
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
    App.user.person.upcomingRides.add(result);
    Cache.setUserCache(App.user);
    Navigator.popUntil(context, (route) => route.isFirst);
    App.updateUpcomingRide.value = true;

    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_added!"));
  }
}

_editRideResponse(Ride result, int code, String message, context) {
  if (code != HttpStatus.ok) {
    CustomToast().showErrorToast(message);
  } else {
    App.user.person.upcomingRides.remove(result);
    App.user.person.upcomingRides.add(result);
    Cache.setUserCache(App.user);
    Navigator.popUntil(context, (route) => route.isFirst);
    App.updateUpcomingRide.value = true;

    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
  }
}

class _Title extends StatelessWidget {
  String text;

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
  String text;
  int maxlines;

  _Value({this.text, this.maxlines});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.topStart,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: Styles.valueTextStyle(),
        maxLines: maxlines,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
