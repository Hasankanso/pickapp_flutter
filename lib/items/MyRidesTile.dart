import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/pages/RideDetails.dart';
import 'package:pickapp/requests/EditReservation.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class MyRidesTile extends StatefulWidget {
  final Ride _ride;
  int reservedSeats, maxSeats;
  int reservedLuggage, maxLuggage;
  bool showSeatsLuggageAsText = false;

  static void seatsLuggagePopUp(BuildContext context, Ride ride) {
    Reservation reservation = ride.reservationOf(App.person);

    if (reservation == null) {
      CustomToast().showErrorToast(
          Lang.getString(context, "Something_Wrong") + " -1000");
      return;
    }

    RideDetails.seatsLuggagePopUp(context, ride, (seats, luggage) {
      if (ride.leavingDate.isBefore(DateTime.now())) {
        return CustomToast()
            .showErrorToast(Lang.getString(context, "Ride_already_started"));
      }

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
      Request<Ride> req = EditReservation(ride, seats, luggage);
      req.send((Ride r, int status, String reason) =>
          _editReservationResponse(context, r, status, reason));
    }, reservation: reservation);
  }

  static void _editReservationResponse(
      BuildContext context, Ride r, int status, String reason) {
    if (status != 200) {
      Navigator.pop(context);
      //todo in backendless you should send a specific case for this validation, and after handling all what we want, w put general validation
      CustomToast()
          .showErrorToast(Lang.getString(context, "Ride_Reserved_Failed"));
    } else {
      App.person.upcomingRides.remove(r);
      App.person.upcomingRides.add(r);
      Cache.setUser(App.user);
      App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Ride_Reserved_Success"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  MyRidesTile(this._ride, {onPressed}) {
    showSeatsLuggageAsText = false;

    if (_ride.reserved != null && _ride.reserved) {
      Reservation reservation = this._ride.findReservationFrom(App.person);

      assert(reservation != null);
      reservedSeats = reservation.seats;
      maxSeats = reservedSeats;
      reservedLuggage = reservation.luggage;
      maxLuggage = reservedLuggage;
    } else {
      reservedSeats = this._ride.reservedSeats;
      maxSeats = this._ride.maxSeats;
      reservedLuggage = this._ride.reservedLuggages;
      maxLuggage = this._ride.maxLuggage;
    }

    if (maxSeats > 8 || maxLuggage > 8) {
      showSeatsLuggageAsText = true;
    }
  }

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
    super.initState();
    if (widget._ride.user == null) {
      user = App.user;
    } else {
      user = widget._ride.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        side: widget._ride.status == "CANCELED"
            ? (!Cache.darkTheme &&
                    MediaQuery.of(context).platformBrightness !=
                        Brightness.dark)
                ? BorderSide(color: Colors.red.shade200, width: 2)
                : BorderSide(color: Colors.red, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(0, 0, 4, 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        onTap: widget._ride.status != "CANCELED"
            ? widget._ride.reserved == true
                ? () {
                    Navigator.of(context).pushNamed("/RideDetails", arguments: [
                      widget._ride,
                      Lang.getString(context, "Edit_Reservation"),
                      (ride) {
                        MyRidesTile.seatsLuggagePopUp(context, widget._ride);
                      },
                      false
                    ]);
                  }
                : () {
                    Navigator.of(context)
                        .pushNamed("/UpcomingRideDetails", arguments: [
                      widget._ride,
                      Lang.getString(context, "Edit_Ride"),
                      (ride) {
                        return Navigator.pushNamed(context, "/EditRide",
                            arguments: ride);
                      }
                    ]);
                  }
            : null,
        title: Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    DateFormat(
                            'EEE', Localizations.localeOf(context).toString())
                        .format(widget._ride.leavingDate),
                    style: Styles.labelTextStyle(),
                  ),
                  VerticalSpacer(
                    height: 20,
                  ),
                  Text(
                      DateFormat(
                              'dd', Localizations.localeOf(context).toString())
                          .format(widget._ride.leavingDate),
                      style: Styles.labelTextStyle()),
                  VerticalSpacer(
                    height: 20,
                  ),
                  Text(
                      DateFormat(
                              'MMM', Localizations.localeOf(context).toString())
                          .format(widget._ride.leavingDate),
                      style: Styles.labelTextStyle()),
                ],
              ),
            ),
            Spacer(),
            Expanded(
              flex: 40,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Spacer(
                                  flex: 1,
                                ),
                                Expanded(
                                  flex: 30,
                                  child: Text(
                                    user.person.firstName.toString() +
                                        " " +
                                        user.person.lastName.toString(),
                                    style: Styles.valueTextStyle(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (widget.showSeatsLuggageAsText)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.airline_seat_recline_extra_rounded,
                                    color: Styles.primaryColor(),
                                    size: Styles.mediumIconSize(),
                                  ),
                                  Text(widget.reservedSeats.toString() +
                                      (widget._ride.reserved
                                          ? ""
                                          : "/${widget.maxSeats}")),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.home_repair_service_rounded,
                                    color: Styles.primaryColor(),
                                    size: Styles.mediumIconSize(),
                                  ),
                                  Text(widget.reservedLuggage.toString() +
                                      (widget._ride.reserved
                                          ? ""
                                          : "/${widget.maxLuggage}")),
                                ],
                              )
                            else
                              RateStars(
                                widget.reservedSeats.toDouble(),
                                mainAxisAlignment: MainAxisAlignment.start,
                                customIcon:
                                    Icons.airline_seat_recline_extra_rounded,
                                customColor: Styles.primaryColor(),
                                maxStars: widget.maxSeats,
                              ),
                            if (!widget.showSeatsLuggageAsText)
                              RateStars(widget.reservedLuggage.toDouble(),
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  customIcon: Icons.home_repair_service_rounded,
                                  customColor: Styles.primaryColor(),
                                  maxStars: widget.maxLuggage),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Column(
                            children: [
                              if (widget._ride.status == "CANCELED")
                                Text(
                                  Lang.getString(context, "Canceled"),
                                  style:
                                      Styles.valueTextStyle(color: Colors.red),
                                ),
                              Text(
                                DateFormat(
                                        'h:mm a',
                                        Localizations.localeOf(context)
                                            .toString())
                                    .format(widget._ride.leavingDate),
                                style: Styles.labelTextStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  VerticalSpacer(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                                              Icon(Icons.panorama_fish_eye,
                                                  color: Styles.primaryColor(),
                                                  size: Styles.smallIconSize()),
                                              Icon(Icons.more_vert,
                                                  color: Styles.primaryColor(),
                                                  size: Styles.smallIconSize()),
                                              Icon(Icons.circle,
                                                  color: Styles.primaryColor(),
                                                  size: Styles.smallIconSize()),
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
                                                    widget._ride.from.name,
                                                    style: Styles
                                                        .headerTextStyle(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                          alignment: Alignment.bottomRight,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
