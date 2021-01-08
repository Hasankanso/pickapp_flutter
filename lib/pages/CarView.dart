import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CarView extends StatelessWidget {
  Car car;


  CarView({this.car});

  @override
  Widget build(BuildContext context) {

    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      backdropOpacity: 0.3,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      parallaxEnabled: true,
      parallaxOffset: .5,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      maxHeight: ScreenUtil().setHeight(280),
      minHeight: ScreenUtil().setHeight(80),
      body: ResponsiveWidget.fullWidth(
        height: 300,
        child: GridTile(
          child: FittedBox(
            fit: BoxFit.fill,
            child: Image(
              image : car.networkImage,
              errorBuilder: (context, url, error) {
                return Image(
                  image: AssetImage("lib/images/car.png"),
                );
              },
            ),
          ),
        ),
      ),
      panelBuilder: (ScrollController sc) => _panel(sc, car),
    );
  }
}

class _panel extends StatelessWidget{

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
           car.brand + ", " + car.name,
           maxLines: 1,
           style: Styles.valueTextStyle(bold: FontWeight.w800),
           overflow: TextOverflow.clip,
           textAlign: TextAlign.center,
         ),
       ),
       VerticalSpacer(height : 20),
       Row(children: [
         Expanded(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Title(
                   text: Lang.getString(context, "Year"),
                 ),
               ),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Title(
                   text: Lang.getString(context, "Type"),
                 ),
               ),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Title(
                   text: Lang.getString(context, "Seats"),
                 ),
               ),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Title(
                   text: Lang.getString(context, "Luggage"),
                 ),
               ),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Title(
                   text: Lang.getString(context, "Color"),
                 ),
               ),
             ],
           ),
         ),
         Expanded(
           child: Column(
             children: [
               ResponsiveWidget.fullWidth(
                   height: 40,child: _Value(text: car.year.toString())),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Value(
                   text: _typeItems[car.type],
                 ),
               ),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Value(
                   text : car.maxSeats.toString(),
                 ),
               ),
               ResponsiveWidget.fullWidth(
                 height: 40,
                 child: _Value(
                   text:  car.maxLuggage.toString(),
                 ),
               ),
               Align(alignment: Alignment.topLeft,
                 child: ResponsiveWidget(
                   width: 30,
                   height: 30,
                   child: Container(
                     decoration: BoxDecoration(
                       color: Color(car.color),
                       borderRadius: BorderRadius.all(Radius.circular(10)),
                     ),
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
