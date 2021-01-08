import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/LineDevider.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Security extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Security"),
        elevation: 0,
      ),
      body: Column(
        children: [
          VerticalSpacer(height: 18),
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
                                color: Theme.of(context).accentIconTheme.color,
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
                                color: Theme.of(context).accentIconTheme.color,
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
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
