import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Spinner.dart';

class MyRidesHistoryTile extends ListTile {
  final Ride _ride;

  MyRidesHistoryTile(this._ride, {onPressed});

  static Function(BuildContext, int) itemBuilder(List<Ride> rides) {
    return (context, index) {
      return MyRidesHistoryTile(rides[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_ride.person.networkImage == null) {
      _ride.person.setNetworkImage();
    }
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
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
                    flex: 4,
                    child: Column(
                      children: [
                        Text(
                          _ride.price.toInt().toString() +
                              " " +
                              Lang.getString(
                                  context, App.person.countryInformations.unit),
                          style: Styles.valueTextStyle(bold: FontWeight.w500),
                        ),
                        if (_ride.status == "CANCELED")
                          Text(
                            Lang.getString(context, "Canceled"),
                            style: Styles.valueTextStyle(color: Colors.red),
                          ),
                      ],
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
                              child: _ride.person.profilePictureUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: _ride.person.profilePictureUrl,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 30,
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 30,
                                        child: Spinner(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 30,
                                        child: Image(
                                            image: AssetImage(
                                                "lib/images/user.png")),
                                      ),
                                    )
                                  : Image(
                                      image: _ride.person.networkImage,
                                      errorBuilder: (context, url, error) {
                                        return Image(
                                          image:
                                              AssetImage("lib/images/user.png"),
                                        );
                                      },
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
