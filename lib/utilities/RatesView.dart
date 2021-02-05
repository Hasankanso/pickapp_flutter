import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/UserStatistics.dart';
import 'package:pickapp/utilities/RateStars.dart';

class RatesView extends StatelessWidget {
  final List<Rate> rates;
  final UserStatistics stats;
  final double rateAverage;

  const RatesView({Key key, this.rates, this.stats, this.rateAverage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int ratesCount =
        stats.fives + stats.fours + stats.threes + stats.twos + stats.ones;

    double fivesRatio = stats.fives / ratesCount;
    double foursRatio = stats.fours / ratesCount;
    double threesRatio = stats.threes / ratesCount;
    double twosRatio = stats.twos / ratesCount;
    double onesRatio = stats.ones / ratesCount;

    double width = ScreenUtil().setWidth(225.0);
    double lineHeight = 10.0;
    Color backgroundColor = Colors.grey.shade300;
    Color mainColor = Colors.green;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              rateAverage.toString(),
              style: Styles.valueTextStyle(size: 45),
            ),
            Row(
              children: [
                Expanded(flex: 15, child: RateStars(rateAverage, size: 11)),
              ],
            ),
            Row(
              children: [
                Spacer(flex: 6),
                Expanded(
                  flex: 15,
                  child: Text(
                    ratesCount.toString(),
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
                    percent: !fivesRatio.isNaN ? fivesRatio : 0,
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
                    percent: !foursRatio.isNaN ? foursRatio : 0,
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
                    percent: !threesRatio.isNaN ? threesRatio : 0,
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
                    percent: !twosRatio.isNaN ? twosRatio : 0,
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
                    percent: !onesRatio.isNaN ? onesRatio : 0,
                    backgroundColor: backgroundColor,
                    progressColor: mainColor,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
