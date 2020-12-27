import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class MyRidesTile extends ListTile {
  final Ride _ride;
  Function(Ride) onPressed;

  MyRidesTile(this._ride, {onPressed});

  static Function(BuildContext, int) itemBuilder(List<Ride> rides, onPressed) {
    return (context, index) {
      return MyRidesTile(rides[index], onPressed: onPressed);
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
                        onTap: () {
                          if (onPressed != null) {
                            onPressed(_ride);
                          }
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
                                                _ride.person.firstName +
                                                    " " +
                                                    _ride.person.lastName,
                                                style: Styles.valueTextStyle(),
                                              ),
                                            ),
                                          ],
                                        ),
                                        RateStars(
                                          _ride.user.person.rateAverage,
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
                                                      bold: FontWeight.w500),
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
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveRow(
              children: [
                RaisedButton(
                  onPressed: () {},
                  child: Text("Cancel Ride"),
                ),
                RaisedButton(
                  onPressed: () {},
                  child: Text("Edit"),
                ),
              ],
            ),
            VerticalSpacer(
              height: 10,
            )
          ],
        ));
  }
}
