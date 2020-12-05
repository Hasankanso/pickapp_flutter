import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/RateStars.dart';

class RideResultListTile extends ListTile {
  final Ride _ride;

  RideResultListTile(this._ride);

  static Function(BuildContext, int) itemBuilder(List<Ride> rides) {
    return (context, index) {
      return RideResultListTile(rides[index]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
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
                    child: Text(
                      _ride.from.name + "\n \n" + _ride.to.name,
                      style: Styles.headerTextStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      _ride.price.toInt().toString() +
                          " " +
                          App.person.countryInformations.unit,
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
                              child: CachedNetworkImage(
                                imageUrl: _ride.person.profilePictureUrl,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 30,
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 30,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Icon(
                                      Icons.account_circle_outlined,
                                      size: ScreenUtil().setSp(100),
                                      color: Styles.primaryColor(),
                                    ),
                                  ),
                                ),
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
                                    _ride.user.person.rateAverage,
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
                                  "04/06 44:30 PM",
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
