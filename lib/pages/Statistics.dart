import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/RatesView.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
          ResponsiveRow(flex: 25, children: [
            Text(
              Lang.getString(context, "Rides"),
              style: Styles.headerTextStyle(),
            ),
          ]),
          ResponsiveRow(
            flex: 30,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13, bottom: 13),
                  child: Column(
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Visibility(
                                  visible: accomplishedCanceledRatio > 0,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 6,
                                        child: Column(children: [
                                          Icon(
                                            Icons.speed,
                                          ),
                                          Text(
                                            (App.user.person.statistics
                                                            .acomplishedRides +
                                                        App
                                                            .user
                                                            .person
                                                            .statistics
                                                            .canceledRides)
                                                    .toInt()
                                                    .toString() +
                                                " " +
                                                Lang.getString(
                                                    context, "Rides"),
                                            style:
                                                Styles.valueTextStyle(size: 12),
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
                                          percent:
                                              !accomplishedCanceledRatio.isNaN
                                                  ? accomplishedCanceledRatio
                                                  : 0,
                                          center: Text(
                                            !accomplishedCanceledRatio.isNaN
                                                ? (accomplishedCanceledRatio *
                                                            100)
                                                        .toInt()
                                                        .toString() +
                                                    "%"
                                                : "0",
                                            style: Styles.buttonTextStyle(
                                                size: 12),
                                          ),
                                          backgroundColor: Colors.red,
                                          progressColor: Colors.green,
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            if (accomplishedCanceledRatio <= 0)
                              Container(
                                constraints: BoxConstraints(
                                    minHeight: ScreenUtil().setHeight(20)),
                                child: Text(
                                  Lang.getString(context, "No_enough_data!"),
                                  style: Styles.valueTextStyle(),
                                ),
                              )
                          ]),
                    ],
                  ),
                ),
              )
            ],
          ),
          VerticalSpacer(height: 18),
          ResponsiveRow(flex: 25, children: [
            Text(
              Lang.getString(context, "Rates"),
              style: Styles.headerTextStyle(),
            ),
          ]),
          ResponsiveRow(
            flex: 30,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 13, bottom: 13),
                  child: Column(
                    children: <Widget>[
                      RatesView(
                        rates: App.user.person.rates,
                        stats: App.user.person.statistics,
                        rateAverage: App.user.person.statistics.rateAverage,
                        isTitle: true,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 275,
        child: MainNativeAd(),
      ),
    );
  }
}
