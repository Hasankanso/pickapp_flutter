import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
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

  deleteRideRequest(context){
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
    Request<bool> request = CancelRide(ride, "hello");
    request.send((result, code, message) {
      return response(result, code, message, context);
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: MainAppBar(
          actions: [
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: Styles.largeIconSize(),
                ),
                tooltip: Lang.getString(context, "Delete"),
                onPressed: ()  {
                  PopUp.areYouSure(
                      Lang.getString(context, "Yes"),
                      Lang.getString(context, "No"),
                      Lang.getString(
                          context, "Ride_delete_message"),
                      Lang.getString(context, "Warning!"),
                      Colors.red,
                          (bool) => bool
                          ? deleteRideRequest(context)
                          : null,
                      highlightYes: true)
                      .confirmationPopup(context);
                })
          ],
          title: Lang.getString(context, "Ride_Details"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.map, size: Styles.mediumIconSize())),
              Tab(
                  icon: Icon(Icons.airline_seat_recline_extra_sharp,
                      size: Styles.mediumIconSize())),
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
      Navigator.pushNamedAndRemoveUntil(
          context, "/", (Route<dynamic> route) => false);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_deleted!"));
    }
  }

}
