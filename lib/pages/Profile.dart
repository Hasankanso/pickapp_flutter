import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/Items/CarListTile.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/requests/EditAccount.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/Line.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainExpansionTile.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MainImageController _imageController = MainImageController();
  _onImagePicked() async {
    Person _person = App.person;
    await _person.setImage(_imageController.pickedImage);
    Request<Person> request = EditAccount(_person);
    request.send(_response);
  }

  _response(Person result, int code, String p3) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(p3);
    } else {
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
      setState(() {
        App.user.person.profilePictureUrl = result.profilePictureUrl;
      });
    }
  }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(240),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: ScreenUtil().setHeight(183),
                    width: double.infinity,
                    color: Cache.darkTheme
                        ? Theme.of(context).primaryColor
                        : Styles.primaryColor(),
                  ),
                  Positioned(
                    left: 15.0,
                    right: 15.0,
                    child: Card(
                      margin: EdgeInsets.all(0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      child: Material(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(7.0),
                        child: Column(
                          children: <Widget>[
                            VerticalSpacer(height: 10),
                            ResponsiveWidget.fullWidth(
                              height: 110,
                              child: Align(
                                alignment: Alignment.center,
                                child: MainImagePicker(
                                  callBack: _onImagePicked,
                                  controller: _imageController,
                                  imageUrl: App.person.profilePictureUrl,
                                ),
                              ),
                            ),
                            Container(
                              height: ScreenUtil().setHeight(120),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        App.user.person.rateAverage,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
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
                          Line(),
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
                            DriverInfo()
                          else
                            PassengerInfo(),
                        ],
                      ),
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

class DriverInfo extends StatefulWidget {
  @override
  _DriverInfoState createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Line(),
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
      Line(),
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
    ]);
  }
}

class PassengerInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Line(),
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
    ]);
  }
}
