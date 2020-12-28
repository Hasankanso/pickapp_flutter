import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Chat.dart';
import 'package:pickapp/dataObjects/Message.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/RateStars.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:pie_chart/pie_chart.dart';
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
    _chattinessItems = <String>[
      Lang.getString(context, "I'm_a_quiet_person"),
      Lang.getString(context, "I_talk_depending_on_my_mood"),
      Lang.getString(context, "I_love_to_chat!"),
    ];

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
      minHeight: ScreenUtil().setHeight(280),
      parallaxEnabled: true,
      parallaxOffset: .5,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 300,
            child: GridTile(
              child: FittedBox(
                fit: BoxFit.fill,
                child: CachedNetworkImage(
                  imageUrl: widget.user.person.profilePictureUrl ?? "",
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: Styles.secondaryColor(),
                    child: Spinner(),
                  ),
                  errorWidget: (context, url, error) {
                    return Image(
                      image: AssetImage("lib/images/user.png"),
                    );
                  },
                ),
              ),
            ),
          ),
          VerticalSpacer(
            height: 100,
          )
        ],
      ),
      panel: Column(children: [
        ResponsiveWidget(
          height : 40,
          width: 220,
          child: MainButton(
            text_key: "Contact",
            onPressed: () {
              Navigator.of(context).pushNamed("/Conversation",
                  arguments: new Chat(
                      id: widget.user.person.id,
                      messages: new List<Message>(),
                      person: widget.user.person,
                      date: DateTime.now(),
                      isNewMessage: true));
            },
          ),
        ),
        VerticalSpacer(height: 20),
        ResponsiveWidget.fullWidth(
          height: 30,
          child: Text(
            widget.user.person.firstName + " " + widget.user.person.lastName,
            maxLines: 1,
            style: Styles.valueTextStyle(bold: FontWeight.w800),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RateStars(
              App.user.person.rateAverage,
            )
          ],
        ),
        VerticalSpacer(
          height: 20,
        ),
        Row(
          children: [
            Spacer(flex: 1),
            Expanded(
              flex: 3,
              child: Card(
                child: PieChart(
                  dataMap: dataMap,
                  ringStrokeWidth: 8,
                  chartLegendSpacing: 30,
                  animationDuration: Duration(milliseconds: 800),
                  chartRadius: ScreenUtil().setSp(50),
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
                    chartValueStyle: Styles.valueTextStyle(),
                    showChartValueBackground: false,
                    showChartValues: true,
                    decimalPlaces: 0,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: true,
                  ),
                ),
              ),
            ),
          ],
        ),
        VerticalSpacer(height: 20),
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(text: Lang.getString(context, "Chattiness")),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  ResponsiveWidget.fullWidth(
                    height: 40,
                    child: Text(
                      _chattinessItems[widget.user.person.chattiness],
                      maxLines: 1,
                      style: Styles.valueTextStyle(),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        _Title(text: Lang.getString(context, "Bio")),
        ResponsiveRow(
          children: [
            ResponsiveWidget.fullWidth(
              height: 40,
              child: Text(
                widget.user.person.bio,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: Styles.valueTextStyle(),
                overflow: TextOverflow.clip,
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
