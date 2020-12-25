import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pie_chart/pie_chart.dart';

class Statistics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "AccomplishedRides": 190,
      "Canceled": 10,
    };
    return MainScaffold(
      appBar: MainAppBar(title: Lang.getString(context, "Statistics")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 30,
                child: PieChart(
                  dataMap: dataMap,
                  ringStrokeWidth: 10,
                  chartLegendSpacing: 30,
                  animationDuration: Duration(milliseconds: 800),
                  chartRadius: ScreenUtil().setSp(100),
                  colorList: [
                    Colors.blue,
                    Colors.red,
                  ],
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  legendOptions: LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendTextStyle: Styles.valueTextStyle(),
                  ),
                  chartValuesOptions: ChartValuesOptions(
                    showChartValueBackground: false,
                    showChartValues: true,
                    decimalPlaces: 0,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: true,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
