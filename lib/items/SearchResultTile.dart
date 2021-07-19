import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/RateStars.dart';

class SearchResultTile extends ListTile {
  final Ride _ride;
  Function(Ride) onPressed;

  SearchResultTile(this._ride, {this.onPressed});

  static Function(BuildContext, int) itemBuilder(List<Ride> rides, onPressed) {
    return (context, index) {
      return SearchResultTile(rides[index], onPressed: onPressed);
    };
  }

  @override
  Widget build(BuildContext context) {
    print(_ride.id);
    print(_ride.user);
    if (_ride.person.networkImage == null) {
      _ride.person.setNetworkImage();
    }
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
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
                    flex: 1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                _ride.from.name,
                                style: Styles.headerTextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                _ride.to.name,
                                style: Styles.headerTextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      _ride.price.toInt().toString() +
                          " " +
                          Lang.getString(
                              context, _ride.person.countryInformations.unit),
                      style: Styles.valueTextStyle(bold: FontWeight.w500),
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
                              flex: 4,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 30,
                                backgroundImage: _ride.person.networkImage,
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
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
                                          _ride.person.firstName +
                                              " " +
                                              _ride.person.lastName,
                                          style: Styles.valueTextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  RateStars(
                                    _ride.user.person.statistics.rateAverage,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 9,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  DateFormat(
                                          App.dateFormat,
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
