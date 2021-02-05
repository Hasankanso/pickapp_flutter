import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class MyRidesTile extends ListTile {
  final Ride _ride;

  MyRidesTile(this._ride, {onPressed});

  static Function(BuildContext, int) itemBuilder(List<Ride> rides) {
    return (context, index) {
      return MyRidesTile(rides[index]);
    };
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
                            .format(_ride.leavingDate),
                        style: Styles.labelTextStyle(),
                      ),
                      VerticalSpacer(
                        height: 20,
                      ),
                      Text(
                          DateFormat('dd',
                                  Localizations.localeOf(context).toString())
                              .format(_ride.leavingDate),
                          style: Styles.labelTextStyle()),
                      VerticalSpacer(
                        height: 20,
                      ),
                      Text(
                          DateFormat('MMM',
                                  Localizations.localeOf(context).toString())
                              .format(_ride.leavingDate),
                          style: Styles.labelTextStyle()),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      ListTile(
                        onTap: App.checkIfDriver(_ride) == true
                            ? () {
                                Navigator.of(context).pushNamed("/RideDetails",
                                    arguments: [
                                      _ride,
                                      Lang.getString(context, "Reserve"),
                                      (ride) {}
                                    ]);
                              }
                            : () {
                                Navigator.of(context).pushNamed(
                                    "/UpcomingRideDetails",
                                    arguments: [
                                      _ride,
                                      "hello",
                                      (ride) {
                                        if (_ride.reserved == false) {
                                          print(_ride.maxSeats);
                                        }
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
                                                _ride.person.firstName
                                                        .toString() +
                                                    " " +
                                                    _ride.person.lastName
                                                        .toString(),
                                                style: Styles.valueTextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        RateStars(
                                          _ride.user.person.statistics
                                              .rateAverage,
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
                                            .format(_ride.leavingDate),
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
                                                      Text(
                                                        _ride.from.name,
                                                        style: Styles
                                                            .headerTextStyle(),
                                                      ),
                                                    ],
                                                  ),
                                                  VerticalSpacer(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        _ride.to.name,
                                                        style: Styles
                                                            .headerTextStyle(),
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
                                                  _ride.price
                                                          .toInt()
                                                          .toString() +
                                                      " " +
                                                      App
                                                          .person
                                                          .countryInformations
                                                          .unit,
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
