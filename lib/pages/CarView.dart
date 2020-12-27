import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CarView extends StatelessWidget {
  Car car;
  List<String> _typeItems;

  CarView({this.car});

  @override
  Widget build(BuildContext context) {
    _typeItems = <String>[
      Lang.getString(context, "Sedan"),
      Lang.getString(context, "SUV"),
      Lang.getString(context, "Hatchback"),
      Lang.getString(context, "Van")
    ];
    return SlidingUpPanel(
      defaultPanelState: PanelState.OPEN,
      backdropOpacity: 0.3,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      parallaxEnabled: true,
      parallaxOffset: .5,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
      maxHeight: ScreenUtil().setHeight(220),
      minHeight: ScreenUtil().setHeight(80),
      body: ResponsiveWidget.fullWidth(
        height: 300,
        child: GridTile(
          child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
              imageUrl: car.carPictureUrl,
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
              ),
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: Styles.secondaryColor(),
                child: Spinner(),
              ),
              errorWidget: (context, url, error) {
                return Image(
                  image: AssetImage("lib/images/car.png"),
                );
              },
            ),
          ),
        ),
      ),
      panel: Column(children: [
        VerticalSpacer(height: 20),
        ResponsiveWidget.fullWidth(
          height: 30,
          child: Text(
            car.brand + ", " + car.name,
            maxLines: 1,
            style: Styles.valueTextStyle(bold: FontWeight.w800),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
        ),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: DifferentSizeResponsiveRow(
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Lang.getString(context, "Year"),
                          style: Styles.labelTextStyle(),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          car.year.toString(),
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: DifferentSizeResponsiveRow(
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Lang.getString(context, "Type"),
                          style: Styles.labelTextStyle(),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _typeItems[car.type],
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: DifferentSizeResponsiveRow(
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Lang.getString(context, "Seats"),
                          style: Styles.labelTextStyle(),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          car.maxSeats.toString(),
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: DifferentSizeResponsiveRow(
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Lang.getString(context, "Language"),
                          style: Styles.labelTextStyle(),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 25,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          car.maxLuggage.toString(),
                          style: Styles.valueTextStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ResponsiveWidget.fullWidth(
          height: 40,
          child: DifferentSizeResponsiveRow(
            children: [
              Expanded(
                flex: 10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          Lang.getString(context, "Color"),
                          style: Styles.labelTextStyle(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(car.color),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 17,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            width: 10,
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
