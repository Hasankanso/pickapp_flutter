import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
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
          children: <Widget>[
            VerticalSpacer(height: 18),
            ResponsiveRow(widgetRealtiveSize: 25, children: [
              Text(
                Lang.getString(context, "Generals"),
                style: Styles.headerTextStyle(),
              ),
            ]),
            ResponsiveRow(
              widgetRealtiveSize: 30,
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
                          Spacer(flex: 2),
                          Text(Lang.getString(context, "Date_In_Range"),
                              style: Styles.valueTextStyle()),
                          Spacer(flex: 16),
                          Switcher(
                              isOn: Cache.dateTimeRangePicker,
                              onChanged: (bool value) =>
                                  {Cache.setDateTimeRangePicker(value)})
                        ]),
                      ),
                      LineDevider(),
                      ResponsiveWidget.fullWidth(
                        height: 55,
                        child: Row(children: [
                          Spacer(flex: 1),
                          Text(Lang.getString(context, "Dark_Mode"),
                              style: Styles.valueTextStyle()),
                          Spacer(flex: 9),
                          Switcher(
                              isOn: Cache.darkTheme,
                              onChanged: (bool value) =>
                                  {App.forceDarkTheme(value)})
                        ]),
                      ),
                    ],
                  ),
                )
              ],
            ),
            VerticalSpacer(height: 18),
            ResponsiveRow(widgetRealtiveSize: 25, children: [
              Text(
                Lang.getString(context, "About"),
                style: Styles.headerTextStyle(),
              ),
            ]),
            ResponsiveRow(
              widgetRealtiveSize: 30,
              children: [
                Card(
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed("/Email");
                        },
                        child: ResponsiveWidget.fullWidth(
                          height: 64,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.alternate_email,
                                  size: Styles.largeIconSize(),
                                  color: !Cache.darkTheme
                                      ? Colors.grey.shade500
                                      : null,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(Lang.getString(context, "Email"),
                                    style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
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
                                  color: !Cache.darkTheme
                                      ? Colors.grey.shade500
                                      : null,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(
                                    Lang.getString(context, "Contact_Us"),
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
                                  color: !Cache.darkTheme
                                      ? Colors.grey.shade500
                                      : null,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(
                                    Lang.getString(context, "Privacy_Policy"),
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
                                  color: !Cache.darkTheme
                                      ? Colors.grey.shade500
                                      : null,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text(
                                    Lang.getString(
                                        context, "Terms_&_Conditions"),
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
              widgetRealtiveSize: 30,
              children: [
                Card(
                  child: Column(
                    children: [
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
                                  color: !Cache.darkTheme
                                      ? Colors.grey.shade500
                                      : null,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Test Size",
                                    style: Styles.valueTextStyle()),
                              ),
                            ],
                          ),
                        ),
                      ),
                      LineDevider(),
                      InkWell(
                        onTap: () async {
                          await Hive.openBox("regions");
                          var regionB = Hive.box("regions");
                          regionB.clear();
                          var userB = Hive.box("user");
                          userB.clear();
                          App.user = null;
                          App.isLoggedIn = false;
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
                                  Icons.cached_outlined,
                                  size: Styles.largeIconSize(),
                                  color: !Cache.darkTheme
                                      ? Colors.grey.shade500
                                      : null,
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              Expanded(
                                flex: 18,
                                child: Text("Clear cache",
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
            VerticalSpacer(height: 60),
          ],
        ),
      ),
    );
  }
}
