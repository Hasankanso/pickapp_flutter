import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';

class RateTile extends ListTile {
  Rate rate;

  RateTile(this.rate);

  static Function(BuildContext, int) itemBuilder(List<Rate> rates) {
    return (context, index) {
      return RateTile(rates[index]);
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
            Row(
              children: [
                Column(  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rate.rater.firstName + " " + rate.rater.lastName),
                    ResponsiveWidget(height : 50, width:  150,child: RateStars(rate.grade)),
                  ],
                ),
                Column( crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat(App.dateFormat,
                              Localizations.localeOf(context).toString())
                          .format(rate.creationDate),
                      style: Styles.labelTextStyle(),
                    ),
                  ],
                ),
              ],
            ),
            Text(rate.comment),
          ],
        ));
  }
}
