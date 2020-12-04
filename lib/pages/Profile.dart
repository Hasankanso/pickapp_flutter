import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/Items/CarListTile.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainExpansionTile.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Profile"),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Styles.secondaryColor(),
              size: Styles.largeIconSize(),
            ),
            tooltip: Lang.getString(context, "Settings"),
            onPressed: () {
              Navigator.of(context).pushNamed("/settings");
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(266),
            child: Stack(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(255),
                  width: double.infinity,
                ),
                Container(
                  height: ScreenUtil().setHeight(183),
                  width: double.infinity,
                  color: Styles.primaryColor(),
                ),
                Positioned(
                  left: 15.0,
                  right: 15.0,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Material(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(7.0),
                      child: Container(
                        height: ScreenUtil().setHeight(240),
                        child: Column(
                          children: <Widget>[
                            VerticalSpacer(height: 10),
                            DifferentSizeResponsiveRow(
                              children: [
                                Expanded(flex: 1, child: SizedBox()),
                                Expanded(
                                  flex: 6,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: _getProfilePicture(),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: ScreenUtil().setHeight(127),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        tooltip:
                                            Lang.getString(context, "Account"),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pushNamed("/Account");
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Styles.primaryColor(),
                                          size: Styles.mediumIconSize(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  App.person.firstName +
                                      " " +
                                      App.person.lastName,
                                  style: Styles.valueTextStyle(
                                      bold: FontWeight.bold),
                                ),
                                Text(
                                  App.person.countryInformations.name,
                                  style: Styles.labelTextStyle(
                                      bold: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    RateStars(
                                      rating: App.user.person.rateAverage,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Card(
                elevation: 3,
                child: Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/Details");
                      },
                      child: ResponsiveWidget.fullWidth(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.public,
                                size: Styles.mediumIconSize(),
                                color: Styles.primaryColor(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                Lang.getString(context, "Details"),
                                style: Styles.valueTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    _buildDivider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/Statistics");
                      },
                      child: ResponsiveWidget.fullWidth(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.bar_chart,
                                size: Styles.mediumIconSize(),
                                color: Styles.primaryColor(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                Lang.getString(context, "Statistics"),
                                style: Styles.valueTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (App.driver != null)
                      ...driverInfo()
                    else
                      ...passengerInfo(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> passengerInfo() {
    return [
      _buildDivider(),
      InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/BecomeDriver");
        },
        child: ResponsiveWidget.fullWidth(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.drive_eta_rounded,
                  size: Styles.mediumIconSize(),
                  color: Styles.primaryColor(),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  Lang.getString(context, "Become_a_driver"),
                  style: Styles.valueTextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> driverInfo() {
    return [
      _buildDivider(),
      InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("/Regions");
        },
        child: ResponsiveWidget.fullWidth(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.location_on_outlined,
                  size: Styles.mediumIconSize(),
                  color: Styles.primaryColor(),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  Lang.getString(context, "Regions"),
                  style: Styles.valueTextStyle(),
                ),
              ),
            ],
          ),
        ),
      ),
      _buildDivider(),
      InkWell(
        onTap: () {},
        child: AnimatedSize(
          curve: Curves.fastLinearToSlowEaseIn,
          vsync: this,
          duration: Duration(milliseconds: 10),
          child: Row(
            children: [
              Expanded(
                child: MainExpansionTile(
                  height: 60,
                  leading: Icon(
                    Icons.local_taxi_outlined,
                    size: Styles.mediumIconSize(),
                    color: Styles.primaryColor(),
                  ),
                  title: Text(
                    Lang.getString(context, "My_cars"),
                    style: Styles.valueTextStyle(),
                  ),
                  children: App.driver.cars.map((Car car) {
                    return CarListTile(car);
                  }).toList(growable: true),
                ),
              ),
            ],
          ),
        ),
      )
    ];
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  _getProfilePicture() {
    if (App.person.profilePictureUrl == null) {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: ScreenUtil().setSp(40),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Icon(
            Icons.person,
            size: ScreenUtil().setSp(100),
            color: Styles.primaryColor(),
          ),
        ),
      );
    }
    return CachedNetworkImage(
      imageUrl: App.person.profilePictureUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: ScreenUtil().setSp(40),
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: ScreenUtil().setSp(40),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Icon(
            Icons.person,
            size: ScreenUtil().setSp(100),
            color: Styles.primaryColor(),
          ),
        ),
      ),
    );
  }
}
