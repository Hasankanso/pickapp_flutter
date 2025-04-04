import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Chat.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/pages/Inbox.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/RatesView.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PersonView extends StatefulWidget {
  final Person person;
  final bool isContactDisabled;
  PersonView({this.person, this.isContactDisabled = false});

  @override
  _PersonViewState createState() => _PersonViewState();
}

class _PersonViewState extends State<PersonView> {
  List<String> _chattinessItems;
  Map<String, double> dataMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chattinessItems = App.getChattiness(context);

    dataMap = {
      Lang.getString(context, "Accomplished_Rides"):
          widget.person.statistics.acomplishedRides.toDouble(),
      Lang.getString(context, "Canceled_Rides"):
          widget.person.statistics.canceledRides.toDouble(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.person.networkImage == null) {
      widget.person.setNetworkImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      backdropOpacity: 0.3,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      maxHeight: ScreenUtil().setHeight(500),
      minHeight: ScreenUtil().setHeight(120),
      parallaxEnabled: true,
      parallaxOffset: .5,
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      panelBuilder: (ScrollController sc) => _Panel(
          controller: sc,
          person: widget.person,
          chattinessItems: _chattinessItems,
          isContactDisabled: widget.isContactDisabled,
          dataMap: dataMap),
      body: ResponsiveWidget.fullWidth(
        height: 480,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: widget.person.profilePictureUrl != null
              ? BoxDecoration(
                  image: DecorationImage(
                    image: widget.person.networkImage,
                    onError: (s, ss) {
                      return Image(image: AssetImage("lib/images/user.png"));
                    },
                    fit: BoxFit.cover,
                  ),
                )
              : null,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.grey.withOpacity(0.1),
              child: FittedBox(
                alignment: Alignment.topCenter,
                fit: BoxFit.contain,
                child: Container(
                  constraints: BoxConstraints(minHeight: 1, minWidth: 1),
                  child: Image(
                    image: widget.person.networkImage,
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
  Person person;
  ScrollController controller;
  List<String> chattinessItems;
  Map<String, double> dataMap;
  double accomplishedCanceledRatio = 0;
  final bool isContactDisabled;
  _Panel(
      {this.person,
      this.controller,
      this.chattinessItems,
      this.dataMap,
      this.isContactDisabled = false}) {
    int ridesCount =
        person.statistics.acomplishedRides + person.statistics.canceledRides;

    if (ridesCount > 0) {
      accomplishedCanceledRatio =
          person.statistics.acomplishedRides / ridesCount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      child: Column(children: [
        if (!isContactDisabled)
          ResponsiveWidget.fullWidth(
            height: 80,
            child: Column(children: [
              VerticalSpacer(height: 10),
              ResponsiveWidget(
                width: 270,
                height: 50,
                child: MainButton(
                  textKey: "Contact",
                  onPressed: () async {
                    Chat chat = await Inbox.getChat(person);
                    chat.person.deviceToken = person.deviceToken;
                    await Inbox.openChat(chat, context);
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
                person.firstName +
                    " " +
                    person.lastName +
                    ", " +
                    App.calculateAge(person.birthday).toString(),
                maxLines: 1,
                style: Styles.valueTextStyle(bold: FontWeight.w800),
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
              ),
              if (person.gender != null)
                Text(
                  person.gender ? Styles.maleIcon : Styles.femaleIcon,
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
                .format(person.creationDate),
            maxLines: 1,
            style: Styles.labelTextStyle(size: 11, bold: FontWeight.bold),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        if (accomplishedCanceledRatio > 0 || person.statistics.ratesCount > 0)
          VerticalSpacer(height: 20),
        if (accomplishedCanceledRatio > 0)
          ResponsiveRow(
            flex: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(children: [
                    Icon(
                      Icons.speed,
                    ),
                    Text(
                      (person.statistics.acomplishedRides +
                                  person.statistics.canceledRides)
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
                      (accomplishedCanceledRatio * 100).toInt().toString() +
                          "%",
                      style: Styles.buttonTextStyle(size: 12),
                    ),
                    backgroundColor: Colors.red,
                    progressColor: Colors.green,
                  ),
                ],
              ),
            ],
          ),
        if (accomplishedCanceledRatio > 0)
          VerticalSpacer(
            height: 30,
          ),
        if (person.statistics.ratesCount > 0)
          ResponsiveWidget.fullWidth(
            height: 150,
            child: RatesView(
              rates: person.rates,
              stats: person.statistics,
              rateAverage: person.statistics.rateAverage,
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
                  chattinessItems[person.chattiness],
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
        if (person.bio != null) _Title(text: Lang.getString(context, "Bio")),
        if (person.bio != null)
          ResponsiveRow(
            children: [
              Text(
                person.bio,
                textAlign: TextAlign.center,
                maxLines: 7,
                style: Styles.valueTextStyle(),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        VerticalSpacer(height: 14),
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
