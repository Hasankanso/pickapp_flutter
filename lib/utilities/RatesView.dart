import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/UserStatistics.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RatesView extends StatelessWidget {
  final List<Rate> rates;
  final UserStatistics stats;
  final double rateAverage;
  final bool pressable;
  final bool isTitle;

  const RatesView(
      {Key key,
      this.rates,
      this.stats,
      this.rateAverage,
      this.pressable = false,
      this.isTitle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fivesRatio, foursRatio, threesRatio, twosRatio, onesRatio;
    fivesRatio = stats.fives / stats.ratesCount;
    foursRatio = stats.fours / stats.ratesCount;
    threesRatio = stats.threes / stats.ratesCount;
    twosRatio = stats.twos / stats.ratesCount;
    onesRatio = stats.ones / stats.ratesCount;

    double width = ScreenUtil().setWidth(225.0);
    double lineHeight = 10.0;
    Color backgroundColor = Colors.grey.shade300;
    Color mainColor = Colors.green;

    if (stats.ratesCount <= 0) {
      return Container(
          child: isTitle
              ? Text(
                  Lang.getString(context, "No_enough_data!"),
                  style: Styles.valueTextStyle(),
                )
              : null);
    }

    return Column(
      children: [
        if (pressable)
          InkWell(
            onTap: () => Navigator.pushNamed(context, "/ReviewsPageList",
                arguments: Person(reviews: rates)),
            child: Row(
              children: [
                ResponsiveSpacer(
                  width: 15,
                ),
                Text(Lang.getString(context, "Reviews")),
                ResponsiveSpacer(
                  width: 230,
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ResponsiveSpacer(height: 5),
        Row(
          children: [
            Expanded(
              flex: 2,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  App.roundRate(rateAverage).toString(),
                  style: Styles.valueTextStyle(size: 45),
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 15,
                        child: RateStars(App.roundRate(rateAverage), size: 11)),
                  ],
                ),
                Row(
                  children: [
                    Spacer(flex: 6),
                    Expanded(
                      flex: 15,
                      child: Text(
                        stats.ratesCount.toString(),
                        style: Styles.subValueTextStyle(),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("5"),
                      LinearPercentIndicator(
                        width: width,
                        lineHeight: lineHeight,
                        percent: fivesRatio,
                        backgroundColor: backgroundColor,
                        progressColor: mainColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("4"),
                      LinearPercentIndicator(
                        width: width,
                        lineHeight: lineHeight,
                        percent: foursRatio,
                        backgroundColor: backgroundColor,
                        progressColor: mainColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("3"),
                      LinearPercentIndicator(
                        width: width,
                        lineHeight: lineHeight,
                        percent: threesRatio,
                        backgroundColor: backgroundColor,
                        progressColor: mainColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("2"),
                      LinearPercentIndicator(
                        width: width,
                        lineHeight: lineHeight,
                        percent: twosRatio,
                        backgroundColor: backgroundColor,
                        progressColor: mainColor,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text("1"),
                      LinearPercentIndicator(
                        width: width,
                        lineHeight: lineHeight,
                        percent: onesRatio,
                        backgroundColor: backgroundColor,
                        progressColor: mainColor,
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
