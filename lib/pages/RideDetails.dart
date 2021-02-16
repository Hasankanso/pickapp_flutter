import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/DriverView.dart';
import 'package:pickapp/pages/RideView.dart';
import 'package:pickapp/requests/CancelReservedSeats.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Spinner.dart';

import 'CarView.dart';

class RideDetails extends StatelessWidget {
  final Ride ride;
  String buttonText;
  void Function(Ride) onPressed;
  bool isEditDisabled;
  TextEditingController _reason = TextEditingController();

  RideDetails(this.ride,
      {this.buttonText, this.onPressed, this.isEditDisabled = true});

  _cancelReservation(bool deleted, int code, String message, context) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      if (deleted) {
        App.person.upcomingRides.remove(ride);
        Cache.setUserCache(App.user);
        CustomToast()
            .showSuccessToast(Lang.getString(context, "Successfully_deleted!"));
        Navigator.popUntil(context, (route) => route.isFirst);
        App.updateUpcomingRide.value = true;
      }
    }
  }

  void handleClick(String value, context) {
    switch (value) {
      case 'Cancel Reservation':
        _reason.text = "";
        Widget _content;
        if (ride.leavingDate.compareTo(DateTime.now()) < 0) {
          return CustomToast().showSuccessToast(
              Lang.getString(context, "Ride_already_started"));
        } else {
          if (ride.leavingDate
                  .compareTo(DateTime.now().add(Duration(hours: -48))) <=
              0) {
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
                    String alpha =
                        Validation.isAlphabeticIgnoreSpaces(context, value);
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
            Lang.getString(context, "Cancel_reserve_message"),
            Lang.getString(context, "Warning!"),
            Colors.red,
            (yesNo) {
              if (yesNo) {
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
                Request<bool> request =
                    CancelReservedSeats(ride, reason: _reason.text);
                request.send((v, p, s) => _cancelReservation(v, p, s, context));
              }
            },
            interest: false,
            content: _content,
          ).confirmationPopup(context);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Ride_Details"),
          actions: [
            if (!isEditDisabled && ride.reserved)
              PopupMenuButton<String>(
                onSelected: (value) => handleClick(value, context),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: "Cancel Reservation",
                      child: Text(
                        Lang.getString(context, "Cancel_Reservation"),
                        style: Styles.valueTextStyle(),
                      ),
                    ),
                  ];
                },
              ),
          ],
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
          physics: NeverScrollableScrollPhysics(),
          children: [
            RideView(ride, buttonText: buttonText, onPressed: onPressed),
            DriverView(user: ride.user),
            CarView(car: ride.car),
          ],
        ),
      ),
    );
  }
}
