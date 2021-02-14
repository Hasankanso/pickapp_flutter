import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

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
                                //hon
                                Navigator.of(context)
                                    .pushNamed("/RideDetails", arguments: [
                                  widget._ride,
                                  Lang.getString(context, "Edit_Reservation"),
                                  (ride) {
                                    print(88);
                                  }
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
