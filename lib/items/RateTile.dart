import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RateTile extends ListTile {
  Rate rate;
  List<String> reasons;

  RateTile(this.rate, this.reasons);

  static Function(BuildContext, int) itemBuilder(
      List<Rate> rates, List<String> reasons) {
    return (context, index) {
      return RateTile(rates[index], reasons);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.fromLTRB(5, 4, 5, 4),
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Spacer(flex: 1),
                      Expanded(
                        flex: 20,
                        child: Text(
                          rate.rater.firstName + " " + rate.rater.lastName,
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Text(
                          DateFormat(App.birthdayFormat,
                                  Localizations.localeOf(context).toString())
                              .format(rate.creationDate),
                          style: Styles.labelTextStyle(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ResponsiveWidget(
                          height: 24, width: 120, child: RateStars(rate.grade)),
                    ],
                  ),
                  Row(
                    children: [
                      ResponsiveSpacer(
                        width: 12,
                        height: 50,
                      ),
                      Text(reasons[rate.reason],
                          style: Styles.labelTextStyle(size: 13.0)),
                    ],
                  ),
                  ResponsiveSpacer(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Expanded(
                          child: Text(
                            rate.comment,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
