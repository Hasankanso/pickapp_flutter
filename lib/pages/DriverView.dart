import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/RatesView.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DriverView extends StatefulWidget {
  final User user;

  DriverView({this.user});

  @override
  _DriverViewState createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverView> {
  List<String> _chattinessItems;
  Map<String, double> dataMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chattinessItems = App.getChattiness(context);

    dataMap = {
      Lang.getString(context, "Accomplished_Rides"):
          widget.user.person.statistics.acomplishedRides.toDouble(),
      Lang.getString(context, "Canceled_Rides"):
          widget.user.person.statistics.canceledRides.toDouble(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      backdropOpacity: 0.3,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      maxHeight: ScreenUtil().setHeight(520),
      minHeight: ScreenUtil().setHeight(120),
      parallaxEnabled: true,
      parallaxOffset: .5,
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      panelBuilder: (ScrollController sc) => _Panel(
          controller: sc,
          user: widget.user,
          chattinessItems: _chattinessItems,
          dataMap: dataMap),
      body: ResponsiveWidget.fullWidth(
        height: 480,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: widget.user.person.profilePictureUrl != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: widget.user.person.networkImage,
                    onError: (s, ss) {
                      return Image(image: AssetImage("lib/images/user.png"));
                    },
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.grey.withOpacity(0.1),
              child: FittedBox(
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                child: Container(
                  constraints: BoxConstraints(minHeight: 1, minWidth: 1),
                  child: Image(
                    image: widget.user.person.networkImage,
                    errorBuilder: (context, url, error) {
                      return Image(
                        image: AssetImage("lib/images/user.png"),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  User user;
  ScrollController controller;
  List<String> chattinessItems;
  Map<String, double> dataMap;
  double accomplishedCanceledRatio = 0;

  _Panel({this.user, this.controller, this.chattinessItems, this.dataMap}) {
    int ridesCount = user.person.statistics.acomplishedRides +
        user.person.statistics.canceledRides;

    if (ridesCount > 0) {
      accomplishedCanceledRatio =
          user.person.statistics.acomplishedRides / ridesCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(children: [
        ResponsiveWidget.fullWidth(
          height: 80,
          child: Column(children: [
            VerticalSpacer(height: 10),
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Contact",
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/Conversation", arguments: user.person);
                },
                isRequest: true,
              ),
            ),
          ]),
        ),
        VerticalSpacer(height: 10),
        ResponsiveWidget.fullWidth(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.person.firstName + " " + user.person.lastName,
                maxLines: 1,
                style: Styles.valueTextStyle(bold: FontWeight.w800),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
              Text(
                user.person.gender ? Styles.maleIcon : Styles.femaleIcon,
                maxLines: 1,
                style: Styles.valueTextStyle(
                    color: Styles.primaryColor(), bold: FontWeight.w800),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        ResponsiveWidget.fullWidth(
          height: 30,
          child: Text(
            DateFormat(App.birthdayFormat,
                    Localizations.localeOf(context).toString())
                .format(user.person.creationDate),
            maxLines: 1,
            style: Styles.labelTextStyle(size: 11, bold: FontWeight.bold),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        if(user.person.statistics.acomplishedRides + user.person.statistics.canceledRides > 0 || user.person.statistics.ratesCount > 0) VerticalSpacer(height: 20),
        if(user.person.statistics.acomplishedRides + user.person.statistics.canceledRides > 0)  ResponsiveRow(
          widgetRealtiveSize: 20,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(children: [
                  Icon(
                    Icons.speed,
                  ),
                  Text(
                    (user.person.statistics.acomplishedRides +
                                user.person.statistics.canceledRides)
                            .toInt()
                            .toString() +
                        " " +
                        Lang.getString(context, "Rides"),
                    style: Styles.valueTextStyle(size: 12),
                  ),
                ]),
                ResponsiveSpacer(
                  width: 30,
                ),
                LinearPercentIndicator(
                  width: ScreenUtil().setWidth(234.0),
                  lineHeight: 16.0,
                  percent: accomplishedCanceledRatio,
                  center: Text(
                    (accomplishedCanceledRatio * 100).toInt().toString() + "%",
                    style: Styles.buttonTextStyle(size: 12),
                  ),
                  backgroundColor: Colors.red,
                  progressColor: Colors.green,
                ),
              ],
            ),
          ],
        ),
        if(user.person.statistics.acomplishedRides + user.person.statistics.canceledRides > 0) VerticalSpacer(
          height: 30,
        ),
        if(user.person.statistics.ratesCount > 0) ResponsiveWidget.fullWidth(
          height: 150,
          child: RatesView(
            rates: user.person.rates,
            stats: user.person.statistics,
            rateAverage: user.person.statistics.rateAverage,
            pressable: true,
          ),
        ),
        VerticalSpacer(height: 15),
        _Title(text: Lang.getString(context, "Chattiness")),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: Row(
            children: [
              ResponsiveSpacer(width: 50),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  chattinessItems[user.person.chattiness],
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  style: Styles.valueTextStyle(),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
        ),
        VerticalSpacer(height: 5),
        _Title(text: Lang.getString(context, "Bio")),
        ResponsiveRow(
          children: [
            ResponsiveWidget.fullWidth(
              height: 65,
              child: Text(
                user.person.bio,
                textAlign: TextAlign.center,
                maxLines: 7,
                style: Styles.valueTextStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class _Title extends StatelessWidget {
  String text;

  _Title({this.text});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 40,
      child: Row(
        children: [
          ResponsiveSpacer(
            width: 15,
          ),
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: Styles.labelTextStyle(bold: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.clip,
              )),
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  String text;
  int maxlines;

  _Value({this.text, this.maxlines});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 40,
      child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            text,
            textAlign: TextAlign.start,
            style: Styles.valueTextStyle(),
            maxLines: maxlines,
            overflow: TextOverflow.ellipsis,
          )),
    );
  }
}
