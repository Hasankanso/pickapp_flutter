import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RideView extends StatelessWidget {
  final Ride ride;
  final String buttonText;
  ScrollController scrollController = new ScrollController();
  void Function(Ride) onPressed;

  RideView(this.ride, {this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (ride.mapImage == null) {
      ride.setMapImage();
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
      maxHeight: ScreenUtil().setHeight(500),
      minHeight: ScreenUtil().setHeight(120),
      panelBuilder: (ScrollController sc) =>
          _panel(sc, buttonText, ride, onPressed),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 480,
            child: GridTile(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Image(
                  height: ScreenUtil().setHeight(40),
                  image: ride.mapImage,
                  errorBuilder: (context, url, error) {
                    return Image(
                      image: AssetImage("lib/images/map.png"),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
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

class _panel extends StatelessWidget {
  ScrollController sc;
  String buttonText;
  Ride ride;
  void Function(Ride) onPressed;
  User user;

  _panel(this.sc, this.buttonText, this.ride, this.onPressed);

  @override
  Widget build(BuildContext context) {
    ride.user != null ? user = ride.user : user = App.user;
    return SingleChildScrollView(
      controller: sc,
      child: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 80,
            child: Column(children: [
              VerticalSpacer(height: 10),
              ResponsiveWidget(
                width: 270,
                height: 50,
                child: MainButton(
                  text: buttonText,
                  onPressed: () {
                    if (onPressed != null) {
                      onPressed(ride);
                    }
                  },
                  isRequest: true,
                ),
              ),
            ]),
          ),
          VerticalSpacer(height: 20),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Title(text: Lang.getString(context, "From")),
                    _Title(text: Lang.getString(context, "To")),
                    _Title(text: Lang.getString(context, "Date")),
                    _Title(text: Lang.getString(context, "Price")),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.from.name,
                        maxLines: 1,
                        style: Styles.valueTextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.to.name,
                        maxLines: 1,
                        style: Styles.valueTextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        DateFormat(App.dateFormat,
                                Localizations.localeOf(context).toString())
                            .format(ride.leavingDate),
                        maxLines: 1,
                        style: Styles.valueTextStyle(),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.price.toString() +
                            " " +
                            Lang.getString(
                                context, user.person.countryInformations.unit),
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
          ResponsiveSpacer(
            height: 20,
          ),
          _Title(text: Lang.getString(context, "Description")),
          ResponsiveRow(children: [
            Text(
              ride.comment,
              style: Styles.valueTextStyle(),
              textAlign: TextAlign.center,
            )
          ]),
          VerticalSpacer(height: 30),
          _Title(text: Lang.getString(context, "Details")),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.pets,
                color: ride.petsAllowed
                    ? Styles.primaryColor()
                    : Styles.labelColor(),
              ),
              Icon(
                ride.smokingAllowed ? Icons.smoking_rooms : Icons.smoke_free,
                color: ride.smokingAllowed
                    ? Styles.primaryColor()
                    : Styles.labelColor(),
              ),
              Icon(
                Icons.ac_unit,
                color: ride.acAllowed
                    ? Styles.primaryColor()
                    : Styles.labelColor(),
              ),
              Icon(
                ride.musicAllowed ? Icons.music_note : Icons.music_off,
                color: ride.musicAllowed
                    ? Styles.primaryColor()
                    : Styles.labelColor(),
              ),
            ],
          ),
          VerticalSpacer(height: 30),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Title(text: Lang.getString(context, "Available_Seats")),
                    _Title(text: Lang.getString(context, "Luggage")),
                    _Title(text: Lang.getString(context, "Kids_Seat")),
                    _Title(text: Lang.getString(context, "Stop_Duration")),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.availableSeats.toString(),
                        maxLines: 1,
                        style: Styles.valueTextStyle(),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.availableLuggages.toString(),
                        maxLines: 1,
                        style: Styles.valueTextStyle(),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.kidSeat == true ? "1" : "0",
                        maxLines: 1,
                        style: Styles.valueTextStyle(),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 40,
                      child: Text(
                        ride.stopTime.toString(),
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
        ],
      ),
    );
  }
}
