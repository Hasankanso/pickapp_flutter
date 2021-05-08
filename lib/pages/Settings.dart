import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/ads/Ads.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/FakeRequests.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/RouteGenerator.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LanguagesDropDown.dart';
import 'package:pickapp/utilities/LineDevider.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/SizeTest.dart';
import 'package:pickapp/utilities/Switcher.dart';

class Settings extends StatelessWidget {
  FlushbarStatus _flushbarStatus = FlushbarStatus.DISMISSED;
  @override
  Widget build(BuildContext context) {
    LocationEditingController fromController = new LocationEditingController(),
        toController = new LocationEditingController();
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer(height: 18),
            ResponsiveRow(flex: 25, children: [
              Text(
                Lang.getString(context, "Generals"),
                style: Styles.headerTextStyle(),
              ),
            ]),
            ResponsiveRow(
              flex: 30,
              children: [
                Card(
                  child: Column(
                    children: <Widget>[
                      ResponsiveWidget.fullWidth(
                        height: 55,
                        child: Row(
                          children: [
                            Spacer(flex: 1),
                            Expanded(
                              flex: 70,
                              child: LanguagesDropdown(),
                            ),
                          ],
                        ),
                      ),
                      LineDevider(),
                      ResponsiveWidget.fullWidth(
                        height: 55,
                        child: Row(children: [
                          Spacer(flex: 1),
                          Expanded(
                            flex: 10,
                            child: Text(Lang.getString(context, "Date_In_Range"),
                                style: Styles.valueTextStyle()),
                          ),
                          IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(
                                Icons.info,
                                color: Styles.primaryColor(),
                                size: Styles.mediumIconSize(),
                              ),
                              onPressed: () {
                                _showDateRangeHint(context);
                              }),
                          Switcher(
                              isOn: Cache.dateTimeRangePicker,
                              onChanged: (bool value) => {Cache.setDateTimeRangePicker(value)})
                        ]),
                      ),
                      LineDevider(),
                      ResponsiveWidget.fullWidth(
                        height: 55,
                        child: Row(children: [
                          Spacer(flex: 1),
                          Expanded(
                            flex: 12,
                            child: Text(Lang.getString(context, "Dark_Mode"),
                                style: Styles.valueTextStyle()),
                          ),
                          Switcher(
                              isOn: Cache.darkTheme,
                              isDisabled:
                                  MediaQuery.of(context).platformBrightness == Brightness.dark,
                              onChanged: (bool value) => {App.setTheme(value)})
                        ]),
                      ),
                      LineDevider(),
                      ResponsiveWidget.fullWidth(
                        height: 55,
                        child: Row(children: [
                          Spacer(flex: 1),
                          Expanded(
                            flex: 12,
                            child: Text(Lang.getString(context, "Disable_Animation"),
                                style: Styles.valueTextStyle()),
                          ),
                          Switcher(
                              isOn: Cache.disableAnimation,
                              onChanged: (bool value) {
                                Cache.setDisableAnimation(value);
                                RouteGenerator.disableAnimation(value);
                              })
                        ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
            VerticalSpacer(height: 18),
            ResponsiveRow(flex: 25, children: [
              Text(
                Lang.getString(context, "About"),
                style: Styles.headerTextStyle(),
              ),
            ]),
            ResponsiveRow(
              flex: 30,
              children: [
                Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/CountriesRestriction");
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.language,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(Lang.getString(context, "Countries_Restriction"),
                                    style: Styles.valueTextStyle()),
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
            VerticalSpacer(height: 18),
            ResponsiveRow(flex: 25, children: [
              Text(
                Lang.getString(context, "About"),
                style: Styles.headerTextStyle(),
              ),
            ]),
            ResponsiveRow(
              flex: 30,
              children: [
                Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/ContactUs");
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.email,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(Lang.getString(context, "Contact_Us"),
                                    style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/PrivacyPolicy");
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.policy,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(Lang.getString(context, "Privacy_Policy"),
                                    style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/TermAndConditions");
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.rule,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(Lang.getString(context, "Terms_&_Conditions"),
                                    style: Styles.valueTextStyle()),
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
            VerticalSpacer(height: 18),
            ResponsiveRow(
              flex: 30,
              children: [
                Card(
                  child: Column(
                    //addRides
                    children: [
                      InkWell(
                        onTap: () async {
                          //todo clear messages and chat
                          Cache.clearHiveCache();
                          App.user = null;
                          App.isDriverNotifier.value = false;
                          App.isLoggedInNotifier.value = false;
                          Navigator.pop(context);
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.logout,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(Lang.getString(context, "Logout"),
                                    style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SizeTest(
                                  width: 260,
                                  height: 80,
                                  body: FromToPicker(
                                    fromController: fromController,
                                    toController: toController,
                                  ),
                                ),
                              ));
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.car_repair,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Test Size", style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () async {
                          FakeRequests.ridesCount = 20;
                          FakeRequests.addRides();
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.create_new_folder,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Generate Rides", style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () {
                          Cache.clearHiveChats();
                          App.updateInbox.value = !App.updateInbox.value;
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.clear,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Wipe Chat", style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () {
                          Ads.showRewardedAd(() => print("hoiii"));
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.clear,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Show Ad", style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () async {
                          await Cache.clearNotifications();
                          App.notifications = [];
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.clear,
                                  size: Styles.largeIconSize(),
                                  color: Theme.of(context).accentIconTheme.color,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Wipe Notification", style: Styles.valueTextStyle()),
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
            VerticalSpacer(height: 18),
          ],
        ),
      ),
    );
  }

  void _showDateRangeHint(context) {
    if (_flushbarStatus == FlushbarStatus.DISMISSED) {
      Flushbar(
        message: Lang.getString(context, "Date_in_range_hint"),
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.decelerate,
        duration: Duration(seconds: 7),
        icon: Icon(
          Icons.info_outline,
          color: Styles.primaryColor(),
          size: Styles.mediumIconSize(),
        ),
        onStatusChanged: (a) {
          _flushbarStatus = a;
        },
        mainButton: IconButton(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.clear,
            color: Styles.secondaryColor(),
            size: Styles.mediumIconSize(),
          ),
        ),
      )..show(context);
    }
  }
}
