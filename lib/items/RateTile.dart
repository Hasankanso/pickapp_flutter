import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
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
    return ResponsiveWidget.fullWidth(
      height: 170,
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: [
              Spacer(flex: 1),
              Expanded(
                flex: 2,
                child: Row(
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
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [

                    ResponsiveWidget(
                        height: 20, width: 120, child: RateStars(rate.grade)),
                  ],
                ),
              ),
              Expanded(flex : 3,
                child: Row(
                  children: [
                    ResponsiveSpacer(
                      width: 12,
                    ),
                    Text(reasons[rate.reason],
                        style: Styles.labelTextStyle(size: 13.0)),
                  ],
                ),
              ),
              Expanded(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Expanded(
                          child: Text(
                            rate.comment,
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow : TextOverflow.ellipsis,
                            style: Styles.valueTextStyle(),
                          ),
                        ),
                      ),
                    ],
                  )),
            ],
          )),
    );
  }
}
