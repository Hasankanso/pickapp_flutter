import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LanguagesDropDown.dart';
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
                      LanguagesDropdown(),
                      Row(children: [
                        Spacer(flex: 1),
                        Text(Lang.getString(context, "Dark_Mode"),
                            style: Styles.valueTextStyle()),
                        Spacer(flex: 9),
                        Switcher(
                            isOn: Cache.darkTheme,
                            onChanged: (bool value) =>
                                {App.forceDarkTheme(value)})
                      ]),
                      Row(children: [
                        Spacer(flex: 1),
                        Text(Lang.getString(context, "Dark_Mode"),
                            style: Styles.valueTextStyle()),
                        Spacer(flex: 9),
                        Switcher(
                            isOn: Cache.dateTimeRangePicker,
                            onChanged: (bool value) =>
                                {Cache.setDateTimeRangePicker(value)})
                      ]),
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
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text(Lang.getString(context, "Contact_Us"),
                            style: Styles.valueTextStyle()),
                        onTap: () {
                          Navigator.of(context).pushNamed("/ContactUs");
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(Icons.policy),
                        title: Text(Lang.getString(context, "Privacy_Policy"),
                            style: Styles.valueTextStyle()),
                        onTap: () {
                          Navigator.of(context).pushNamed("/PrivacyPolicy");
                        },
                      ),
                      _buildDivider(),
                      ListTile(
                        leading: Icon(Icons.rule),
                        title: Text(
                            Lang.getString(context, "Terms_&_Conditions"),
                            style: Styles.valueTextStyle()),
                        onTap: () {
                          Navigator.of(context).pushNamed("/TermAndConditions");
                        },
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
                      ListTile(
                          leading: Icon(Icons.car_repair),
                          title:
                              Text("Test Size", style: Styles.valueTextStyle()),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SizeTest(
                                      body: FromToPicker(
                                        fromController: fromController,
                                        toController: toController,
                                      ),
                                      width: 120,
                                      height: 80),
                                ));
                          }),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 60.0),
          ],
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
