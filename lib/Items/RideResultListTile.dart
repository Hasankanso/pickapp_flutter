import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RideResultListTile extends ListTile {
  final Ride o;

  RideResultListTile(this.o);

  static Function(BuildContext, int) itemBuilder(List<Ride> rides) {
    return (context, index) {
      return RideResultListTile(rides[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    Ride r = o;
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        o.from.name,
                        style: Styles.headerTextStyle(),
                      ),
                      VerticalSpacer(
                        height: 4,
                      ),
                      Text(
                        o.to.name,
                        style: Styles.headerTextStyle(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          o.price.toInt().toString() +
                              " " +
                              App.person.countryInformations.unit,
                          style: Styles.valueTextStyle(bold: FontWeight.w500),
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 10,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            backgroundImage: AssetImage("lib/images/adel.png"),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 80,
                                    child: Text(
                                      o.person.firstName +
                                          " " +
                                          o.person.lastName,
                                      style: Styles.valueTextStyle(),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: RateStars(
                                      rating: o.user.person.rateAverage,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        "04/06 04:30 PM",
                                        style: Styles.labelTextStyle(),
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
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
