import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/RouteGenerator.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/packages/FlushBar/flushbar.dart';
import 'package:just_miles/requests/Logout.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/LanguagesDropDown.dart';
import 'package:just_miles/utilities/LineDevider.dart';
import 'package:just_miles/utilities/LocationFinder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Switcher.dart';

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
                Lang.getString(context, "Parameters"),
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
                          print("session token");
                          print(App.user.sessionToken);
                          Request<bool> request = Logout();
                          request.send((result, code, message) {
                            return response(result, code, message, context);
                          });
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

  response(bool result, int code, String message, context) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }

    await App.logout();
    CustomToast().showSuccessToast(Lang.getString(context, "Logout_message"));
    Navigator.pop(context);
  }
}
