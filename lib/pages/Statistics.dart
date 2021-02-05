import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/RatesView.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var accomplishedCanceledRatio =
        App.user.person.statistics.acomplishedRides /
            (App.user.person.statistics.acomplishedRides +
                App.user.person.statistics.canceledRides);
    return MainScaffold(
      appBar: MainAppBar(title: Lang.getString(context, "Statistics")),
      body: Column(
        children: [
          VerticalSpacer(height: 18),
          ResponsiveRow(widgetRealtiveSize: 25, children: [
            Text(
              Lang.getString(context, "Rides"),
              style: Styles.headerTextStyle(),
            ),
          ]),
          ResponsiveRow(
            widgetRealtiveSize: 30,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Column(
                    children: <Widget>[
                      ResponsiveWidget.fullWidth(
                        height: 55,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(children: [
                                Icon(
                                  Icons.speed,
                                ),
                                Text(
                                  (App.user.person.statistics.acomplishedRides +
                                              App.user.person.statistics
                                                  .canceledRides)
                                          .toInt()
                                          .toString() +
                                      " " +
                                      Lang.getString(context, "Rides"),
                                  style: Styles.valueTextStyle(size: 12),
                                ),
                              ]),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 20,
                              child: LinearPercentIndicator(
                                width: ScreenUtil().setWidth(234.0),
                                lineHeight: 16.0,
                                percent: !accomplishedCanceledRatio.isNaN
                                    ? accomplishedCanceledRatio
                                    : 0,
                                center: Text(
                                  !accomplishedCanceledRatio.isNaN
                                      ? (accomplishedCanceledRatio * 100)
                                              .toInt()
                                              .toString() +
                                          "%"
                                      : "0",
                                  style: Styles.buttonTextStyle(size: 12),
                                ),
                                backgroundColor: Colors.red,
                                progressColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          VerticalSpacer(height: 18),
          ResponsiveRow(widgetRealtiveSize: 25, children: [
            Text(
              Lang.getString(context, "Rates"),
              style: Styles.headerTextStyle(),
            ),
          ]),
          ResponsiveRow(
            widgetRealtiveSize: 30,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13, bottom: 13),
                  child: Column(
                    children: <Widget>[
                      RatesView(
                          rates: App.user.person.rates,
                          stats: App.user.person.statistics,
                          rateAverage: App.user.person.statistics.rateAverage),
                    ],
                  ),
                ),
              )
            ],
          ),
          VerticalSpacer(height: 18),
        ],
      ),
    );
  }
}
