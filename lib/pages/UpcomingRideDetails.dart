import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/CancelRide.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Spinner.dart';

import 'PassengersView.dart';
import 'RideView.dart';

class UpcomingRideDetails extends StatelessWidget {
  final Ride ride;
  String buttonText;
  void Function(Ride) onPressed;

  UpcomingRideDetails(this.ride, {this.buttonText, this.onPressed});

  TextEditingController _reason = TextEditingController();

  _openCancelPopUp(context) {
    Widget _content;
    if (ride.leavingDate.compareTo(DateTime.now()) < 0) {
      return CustomToast().showErrorToast(Lang.getString(context, "Ride_already_started"));
    } else {
      if (ride.leavingDate.compareTo(DateTime.now().add(App.availableDurationToRate)) <= 0) {
        _content = Column(
          children: [
            TextFormField(
              controller: _reason,
              minLines: 3,
              maxLines: 4,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                LengthLimitingTextInputFormatter(400),
              ],
              decoration: InputDecoration(
                labelText: Lang.getString(context, "Reason"),
                labelStyle: Styles.labelTextStyle(),
              ),
              style: Styles.valueTextStyle(),
              validator: (value) {
                String valid = Validation.validate(value, context);
                String alpha = Validation.isAlphaNumericIgnoreSpaces(context, value);
                String short = Validation.isShort(context, value, 15);

                if (valid != null)
                  return valid;
                else if (short != null)
                  return short;
                else if (alpha != null) return alpha;
                return null;
              },
            ),
          ],
        );
      }
      PopUp.areYouSure(
        Lang.getString(context, "Yes"),
        Lang.getString(context, "No"),
        Lang.getString(context, "Ride_cancel_message"),
        Lang.getString(context, "Warning!"),
        Colors.red,
        (yesNo) {
          if (yesNo) {
            cancelRideRequest(context);
          }
        },
        highlightYes: true,
        content: _content,
      ).confirmationPopup(context);
    }
  }

  cancelRideRequest(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Spinner(),
          ),
        );
      },
    );
    Request<bool> request = CancelRide(ride, _reason.text);
    request.send((result, code, message) {
      return response(result, code, message, context);
    });
  }

  void handleClick(String value, context) {
    switch (value) {
      case 'Cancel Ride':
        _openCancelPopUp(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MainAppBar(
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) => handleClick(value, context),
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: "Cancel Ride",
                    child: Text(
                      Lang.getString(context, "Cancel_Ride"),
                      style: Styles.valueTextStyle(),
                    ),
                  ),
                ];
              },
            ),
          ],
          title: Lang.getString(context, "Ride_Details"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map, size: Styles.mediumIconSize())),
              Tab(
                  icon:
                      Icon(Icons.airline_seat_recline_extra_sharp, size: Styles.mediumIconSize())),
            ],
          ),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            RideView(ride, buttonText: buttonText, onPressed: onPressed),
            ride.passengers != null
                ? PassengersView(ride.passengers)
                : Center(
                    child: Text(
                    Lang.getString(context, "No_passengers_yet!"),
                    style: Styles.valueTextStyle(),
                  ))
          ],
        ),
      ),
    );
  }

  response(bool result, int code, String message, context) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      App.deleteRideFromMyRides(ride);
      Navigator.popUntil(context, (route) => route.isFirst);
      CustomToast().showSuccessToast(Lang.getString(context, "Successfully_canceled!"));
    }
  }
}
