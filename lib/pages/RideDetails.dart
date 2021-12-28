import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/pages/PersonView.dart';
import 'package:just_miles/pages/RideView.dart';
import 'package:just_miles/requests/CancelReservedSeats.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/NumberPicker.dart';
import 'package:just_miles/utilities/PopUp.dart';
import 'package:just_miles/utilities/Spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../classes/Cache.dart';
import 'CarView.dart';

class RideDetails extends StatelessWidget {
  final Ride ride;
  String buttonText;
  void Function(Ride) onPressed;
  bool isEditDisabled;
  bool isContactDisabled;
  TextEditingController _reason = TextEditingController();
  List<Ride> ridesHistory = [];

  RideDetails(this.ride,
      {this.buttonText,
      this.onPressed,
      this.isEditDisabled = true,
      this.isContactDisabled = false});

  _cancelReservation(bool deleted, int code, String message, context) async {
    if (App.handleErrors(context, code, message)) {
      Navigator.pop(context);
      return;
    }

    if (deleted) {
      App.deleteRideFromMyRides(ride);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_canceled!"));
      ridesHistory = await Cache.getRidesHistory();
      ridesHistory.add(ride);
      await Cache.updateRideHistory(ridesHistory);
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void handleClick(String value, context) {
    switch (value) {
      case 'Cancel Reservation':
        _reason.text = "";
        Widget _content;
        if (ride.leavingDate.compareTo(DateTime.now()) < 0) {
          return CustomToast()
              .showErrorToast(Lang.getString(context, "Ride_already_started"));
        } else {
          if (ride.leavingDate
                  .compareTo(DateTime.now().add(App.availableDurationToRate)) <=
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
                    String short = Validation.isShort(context, value, 5);

                    if (valid != null)
                      return valid;
                    else if (short != null) return short;
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
            highlightYes: true,
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
            PersonView(
              person: ride.user.person,
              isContactDisabled: isContactDisabled,
            ),
            CarView(car: ride.car),
          ],
        ),
      ),
    );
  }

  static void seatsLuggagePopUp(
      BuildContext context, Ride ride, Function(int, int) onPressed,
      {Reservation reservation}) {
    bool isReserveSeats = false;
    if (reservation == null) {
      isReserveSeats = true;
      reservation = new Reservation(seats: 1, luggage: 0);
    }

    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black45,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: Styles.labelTextStyle(),
      descStyle: Styles.valueTextStyle(),
      animationDuration: Duration(milliseconds: 400),
    );
    NumberController seatsController = new NumberController();
    NumberController luggageController = new NumberController();
    Alert(
        context: context,
        style: alertStyle,
        title: Lang.getString(context, "Reserve"),
        desc: Lang.getString(context, "Reserve_Seats_Luggage"),
        content: Column(
          children: [
            NumberPicker(
              seatsController,
              "Seats",
              reservation.seats,
              ride.availableSeats,
              isSmallIconSize: true,
            ),
            NumberPicker(
              luggageController,
              "Luggage",
              reservation.luggage,
              ride.availableLuggage,
              isSmallIconSize: true,
            ),
          ],
        ),
        buttons: [
          DialogButton(
            child: Text(Lang.getString(context, "Confirm"),
                style: Styles.buttonTextStyle(),
                overflow: TextOverflow.visible),
            color: Styles.primaryColor(),
            onPressed: () {
              if (!isReserveSeats) {
                if (reservation.seats == seatsController.chosenNumber &&
                    reservation.luggage == luggageController.chosenNumber) {
                  return CustomToast().showErrorToast(
                      Lang.getString(context, "Reservation_editing_message"));
                }
              }

              onPressed(
                  seatsController.chosenNumber, luggageController.chosenNumber);
            },
          ),
        ]).show();
  }
}
