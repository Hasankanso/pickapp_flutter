import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
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
          widget.user.person.acomplishedRides.toDouble(),
      Lang.getString(context, "Canceled_Rides"):
          widget.user.person.canceledRides.toDouble(),
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
    accomplishedCanceledRatio = user.person.acomplishedRides /
        (user.person.acomplishedRides + user.person.canceledRides);
  }

  @override
  Widget build(BuildContext context) {
    List<Rate> rates = new List<Rate>();
    Person p1 = new Person(firstName: "Ali", lastName: "Loubani");
    Person p2 = new Person(firstName: "Adel", lastName: "Kanso");
    rates.add(new Rate(
        grade: 4,
        comment: "he's friendly guy, would do it again!",
        reason: 0,
        rater: p1,
        creationDate: DateTime.now()));
    rates.add(new Rate(
        grade: 2,
        comment:
            "he's guy, would do it again asd esdf sf vsd sdf sdgfsdg dfg dfg fd g dsfgbdg hd glkfdsjg dflk gjf glkdfjg fdlkjlk!",
        reason: 2,
        rater: p2,
        creationDate: DateTime.now()));
    rates.add(new Rate(
        grade: 1,
        comment: "he's fr again!",
        reason: 2,
        rater: p1,
        creationDate: DateTime.now()));
    rates.add(new Rate(
        grade: 5,
        comment: "he's friendly guy, would do it again!",
        reason: 2,
        rater: p1,
        creationDate: DateTime.now()));
    rates.add(new Rate(
        grade: 3,
        comment: " again!",
        reason: 2,
        rater: p2,
        creationDate: DateTime.now()));

    user.person.rates = rates;
    user.person.rateAverage = 4.8;

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
          child: Text(
            user.person.firstName + " " + user.person.lastName,
            maxLines: 1,
            style: Styles.valueTextStyle(bold: FontWeight.w800),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        VerticalSpacer(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveSpacer(
              width: 45,
            ),
            Column(children: [
              Icon(
                Icons.speed,
              ),
              Text(
                (user.person.acomplishedRides + user.person.canceledRides)
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
        VerticalSpacer(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/RatesView",
                  arguments: user.person.rates),
              child: ResponsiveWidget.fullWidth(
                height: 150,
                child: RatesView(
                    rates: user.person.rates,
                    stats: user.person.statistics,
                    rateAverage: user.person.rateAverage),
              ),
            ),
          ],
        ),
        VerticalSpacer(height: 15),
        _Title(text: Lang.getString(context, "Chattiness")),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: Row(
            children: [
              ResponsiveSpacer(width: 15),
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
