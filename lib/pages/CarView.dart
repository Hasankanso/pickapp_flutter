import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CarView extends StatelessWidget {
  Car car;

  CarView({this.car});

  @override
  Widget build(BuildContext context) {
    if (car.networkImage == null) {
      car.setNetworkImage();
    }
    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      backdropOpacity: 0.3,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      parallaxEnabled: true,
      parallaxOffset: .5,
      color: Theme.of(context).scaffoldBackgroundColor,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      maxHeight: ScreenUtil().setHeight(320),
      minHeight: ScreenUtil().setHeight(120),
      panelBuilder: (ScrollController sc) => _panel(sc, car),
      body: ResponsiveWidget.fullWidth(
        height: 480,
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: car.networkImage,
              onError: (s, ss) {
                return Image(image: AssetImage("lib/images/car.png"));
              },
              fit: BoxFit.cover,
            ),
          ),
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
                    image: car.networkImage,
                    errorBuilder: (context, url, error) {
                      return Image(
                        image: AssetImage("lib/images/car.png"),
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

class _panel extends StatelessWidget {
  ScrollController sc;
  Car car;
  List<String> _typeItems;

  _panel(this.sc, this.car);

  @override
  Widget build(BuildContext context) {
    _typeItems = <String>[
      Lang.getString(context, "Sedan"),
      Lang.getString(context, "SUV"),
      Lang.getString(context, "Hatchback"),
      Lang.getString(context, "Van")
    ];

    return SingleChildScrollView(
      controller: sc,
      child: Column(children: [
        VerticalSpacer(height: 20),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: Text(
            Lang.getString(context, car.brand) + ", " + car.name,
            maxLines: 1,
            style: Styles.valueTextStyle(bold: FontWeight.w800),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        VerticalSpacer(height: 20),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(
                  text: Lang.getString(context, "Year"),
                ),
                _Title(
                  text: Lang.getString(context, "Type"),
                ),
                _Title(
                  text: Lang.getString(context, "Seats"),
                ),
                _Title(
                  text: Lang.getString(context, "Luggage"),
                ),
                _Title(
                  text: Lang.getString(context, "Color"),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _Value(text: car.year.toString()),
                _Value(
                  text: _typeItems[car.type],
                ),
                _Value(
                  text: car.maxSeats.toString(),
                ),
                _Value(
                  text: car.maxLuggage.toString(),
                ),
                Align(
                  alignment: App.isLTR ? Alignment.topLeft : Alignment.topRight,
                  child: ResponsiveWidget(
                    width: 30,
                    height: 30,
                    child: FloatingActionButton(
                      elevation: 2,
                      backgroundColor: Color(car.color),
                      onPressed: null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
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
      child: Row(
        children: [
          Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: Styles.valueTextStyle(),
                maxLines: maxlines,
                overflow: TextOverflow.ellipsis,
              )),
        ],
      ),
    );
  }
}
