import 'package:flutter/material.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/LineDevider.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class Security extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Security"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(height: 18),
            ResponsiveRow(
              flex: 30,
              children: [
                Card(
                  child: ValueListenableBuilder(
                    builder:
                        (BuildContext context, bool isLoggedIn, Widget child) {
                      return Column(
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
                                      color: Theme.of(context)
                                          .accentIconTheme
                                          .color,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 18,
                                    child: Text(App.user.email,
                                        style: Styles.valueTextStyle()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          LineDevider(),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, "/Phone");
                            },
                            child: ResponsiveWidget.fullWidth(
                              height: 64,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Icon(
                                      Icons.phone,
                                      size: Styles.largeIconSize(),
                                      color: Theme.of(context)
                                          .accentIconTheme
                                          .color,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 18,
                                    child: Text(App.user.phone,
                                        style: Styles.valueTextStyle()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    valueListenable: App.updateProfile,
                  ),
                ),
              ],
            ),
            VerticalSpacer(
              height: 40,
            ),
            ResponsiveRow(flex: 30, children: [
              ResponsiveWidget.fullWidth(
                height: 300,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                      flex: 60,
                      child: MainNativeAd(),
                    ),
                  ],
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
