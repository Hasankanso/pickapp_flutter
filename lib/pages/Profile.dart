import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/items/CarListTile.dart';
import 'package:just_miles/requests/EditAccount.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/LineDevider.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainExpansionTile.dart';
import 'package:just_miles/utilities/MainImagePicker.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/RateStars.dart';
import 'package:just_miles/utilities/Responsive.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MainImageController _imageController = MainImageController();
  bool _isImageLoading = false;

  _onImagePicked(File imageFile) async {
    _isImageLoading = true;
    setState(() {});
    Person _person = App.person;
    App.person.profilePictureUrl =
        await Request.uploadImage(imageFile.path, VoomcarImageType.Profile);

    Request<Person> request = EditAccount(_person);
    await request.send(
        (result, code, message) => _response(result, code, message, context));
  }

  _response(Person result, int code, String message, context) async {
    if (App.handleErrors(context, code, message)) {
      _isImageLoading = false;
      return;
    }

    List<Ride> upcomingRides = List<Ride>.from(App.person.upcomingRides);
    List<Rate> rates = App.person.rates;

    result.upcomingRides = upcomingRides;
    result.rates = rates;
    result.statistics = App.user.person.statistics;
    result.countryInformations = App.user.person.countryInformations;

    App.user.person = result;
    await Cache.setUser(App.user);
    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    setState(() {
      _isImageLoading = false;
      App.user.person = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, bool isLoggedIn, Widget child) {
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
                  Navigator.of(context).pushNamed("/Settings");
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
                        color: Theme.of(context).primaryColor,
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
                                      isLoading: _isImageLoading,
                                      controller: _imageController,
                                      imageUrl: App.person.profilePictureUrl,
                                      title: Lang.getString(context, "Me"),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: ScreenUtil().setHeight(120),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          RateStars(
                                            App.user.person.statistics
                                                .rateAverage,
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, "/ReviewsPageList");
                                            },
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
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 5.0),
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
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(7.0),
                                    topLeft: Radius.circular(7.0)),
                                child: ResponsiveWidget.fullWidth(
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                              LineDevider(),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/Security");
                                },
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(7.0),
                                    bottomLeft: Radius.circular(7.0)),
                                child: ResponsiveWidget.fullWidth(
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Icon(
                                          Icons.security,
                                          size: Styles.mediumIconSize(),
                                          color: Styles.primaryColor(),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 6,
                                        child: Text(
                                          Lang.getString(context, "Security"),
                                          style: Styles.valueTextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
                          child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              child: Column(children: [
                                ValueListenableBuilder(
                                  builder: (BuildContext context, bool isDriver,
                                      Widget child) {
                                    if (isDriver) {
                                      return DriverInfo();
                                    } else {
                                      return PassengerInfo();
                                    }
                                  },
                                  valueListenable: App.isDriverNotifier,
                                ),
                              ]))))
                ]),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 8.0),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("/Statistics");
                                },
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(7.0),
                                    topLeft: Radius.circular(7.0)),
                                child: ResponsiveWidget.fullWidth(
                                  height: 60,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
      },
      valueListenable: App.updateProfile,
    );
  }
}

class DriverInfo extends StatefulWidget {
  @override
  _DriverInfoState createState() => _DriverInfoState();
}

class _DriverInfoState extends State<DriverInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () {
          Navigator.of(context)
              .pushNamed("/BecomeDriver", arguments: [true, false]);
        },
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(7.0), topLeft: Radius.circular(7.0)),
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
      LineDevider(),
      InkWell(
        onTap: () {},
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(7.0),
            bottomLeft: Radius.circular(7.0)),
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
                trailing: !(App.driver.cars.length >= 3)
                    ? IconButton(
                        tooltip: Lang.getString(context, "Add_a_car"),
                        onPressed: () {
                          Navigator.pushNamed(context, "/AddCar");
                        },
                        icon: Icon(
                          Icons.add,
                          color: Styles.primaryColor(),
                          size: Styles.largeIconSize(),
                        ),
                      )
                    : null,
                children: App.driver.cars.map((Car car) {
                  return CarListTile(car);
                }).toList(growable: true),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}

class PassengerInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        Navigator.of(context)
            .pushNamed("/BecomeDriver", arguments: [false, true]);
      },
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Styles.primaryColor(),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
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
                color: Styles.secondaryColor(),
              ),
            ),
            Expanded(
              flex: 6,
              child: Text(
                Lang.getString(context, "Become_a_driver"),
                style: Styles.valueTextStyle(color: Colors.white),
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
