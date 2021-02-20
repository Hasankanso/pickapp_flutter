import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Passenger.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/EditReservation.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyRidesTile extends StatefulWidget {
  final Ride _ride;

  MyRidesTile(this._ride, {onPressed});

  static Function(BuildContext, int) itemBuilder(List<Ride> rides) {
    return (context, index) {
      return MyRidesTile(rides[index]);
    };
  }

  @override
  _MyRidesTileState createState() => _MyRidesTileState();
}

class _MyRidesTileState extends State<MyRidesTile> {
  User user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget._ride.user == null) {
      user = App.user;
    } else {
      user = widget._ride.user;
    }
  }

  void seatsLuggagePopUp(Ride ride, BuildContext context) {

    Passenger reservation = ride.reservationOf(App.person);


    if (reservation == null) {
      CustomToast().showErrorToast(
        Lang.getString(context, "Something_Wrong") + " 3450",
      );
      return;
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
        title: Lang.getString(context, "Edit_Reservation"),
        desc: Lang.getString(context, "Reserve_Seats_Luggage"),
        content: Column(
          children: [
            NumberPicker(
              seatsController,
              "Seats",
              1 + reservation.seats,
              ride.availableSeats + reservation.seats,
              isSmallIconSize: true,
            ),
            NumberPicker(
              luggageController,
              "Luggage",
              0,
              ride.availableLuggages + reservation.luggages,
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
              Request<Ride> req = EditReservation(ride,
                  seatsController.chosenNumber, luggageController.chosenNumber);
              req.send(_response);
            },
          ),
        ]).show();
  }

  void _response(Ride r, int status, String reason) {
    if (status != 200) {
      Navigator.pop(context);
      //todo in backendless you should send a specific case for this validation, and after handling all what we want, w put general validation
      CustomToast()
          .showErrorToast(Lang.getString(context, "Ride_Reserved_Failed"));
    } else {
      App.person.upcomingRides.remove(r);
      App.person.upcomingRides.add(r);
      Cache.setUserCache(App.user);
      App.updateUpcomingRide.value = true;
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Ride_Reserved_Success"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEE',
                                Localizations.localeOf(context).toString())
                            .format(widget._ride.leavingDate),
                        style: Styles.labelTextStyle(),
                      ),
                      VerticalSpacer(
                        height: 20,
                      ),
                      Text(
                          DateFormat('dd',
                                  Localizations.localeOf(context).toString())
                              .format(widget._ride.leavingDate),
                          style: Styles.labelTextStyle()),
                      VerticalSpacer(
                        height: 20,
                      ),
                      Text(
                          DateFormat('MMM',
                                  Localizations.localeOf(context).toString())
                              .format(widget._ride.leavingDate),
                          style: Styles.labelTextStyle()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: widget._ride.reserved == true
                            ? () {
                                Navigator.of(context)
                                    .pushNamed("/RideDetails", arguments: [
                                  widget._ride,
                                  Lang.getString(context, "Edit_Reservation"),
                                  (ride) {
                                    seatsLuggagePopUp(widget._ride, context);
                                  },
                                  false
                                ]);
                              }
                            : () {
                                Navigator.of(context).pushNamed(
                                    "/UpcomingRideDetails",
                                    arguments: [
                                      widget._ride,
                                      Lang.getString(context, "Edit_Ride"),
                                      (ride) {
                                        return Navigator.pushNamed(
                                            context, "/EditRide",
                                            arguments: ride);
                                      }
                                    ]);
                              },
                        title: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Spacer(
                                              flex: 1,
                                            ),
                                            Expanded(
                                              flex: 30,
                                              child: Text(
                                                user.person.firstName
                                                        .toString() +
                                                    " " +
                                                    user.person.lastName
                                                        .toString(),
                                                style: Styles.valueTextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        RateStars(
                                          user.person.statistics.rateAverage,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        DateFormat(
                                                'h:mm a',
                                                Localizations.localeOf(context)
                                                    .toString())
                                            .format(widget._ride.leavingDate),
                                        style: Styles.labelTextStyle(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                        Icons.panorama_fish_eye,
                                                        color: Styles
                                                            .primaryColor(),
                                                        size: Styles
                                                            .smallIconSize()),
                                                    Icon(Icons.more_vert,
                                                        color: Styles
                                                            .primaryColor(),
                                                        size: Styles
                                                            .smallIconSize()),
                                                    Icon(Icons.circle,
                                                        color: Styles
                                                            .primaryColor(),
                                                        size: Styles
                                                            .smallIconSize()),
                                                  ]),
                                            ),
                                            Expanded(
                                              flex: 12,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          widget
                                                              ._ride.from.name,
                                                          style: Styles
                                                              .headerTextStyle(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  VerticalSpacer(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          widget._ride.to.name,
                                                          style: Styles
                                                              .headerTextStyle(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  widget._ride.price
                                                          .toInt()
                                                          .toString() +
                                                      " " +
                                                      Lang.getString(
                                                          context,
                                                          user
                                                              .person
                                                              .countryInformations
                                                              .unit),
                                                  style: Styles.valueTextStyle(
                                                      bold: FontWeight.w400),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              VerticalSpacer(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
