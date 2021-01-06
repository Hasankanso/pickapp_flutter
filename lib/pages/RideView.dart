 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/App.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/ReserveSeat.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class RideView extends StatelessWidget {
  final Ride ride;
  final String buttonTextKey;
  ScrollController scrollController = new ScrollController();

  RideView({this.ride, this.buttonTextKey});

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
      maxHeight: ScreenUtil().setHeight(500),
      minHeight: ScreenUtil().setHeight(120),

      panelBuilder: (ScrollController sc) => _panel(sc, buttonTextKey, ride),

      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height : 480,
            child: GridTile(
              child: FittedBox(
                fit: BoxFit.fill,
                child: CachedNetworkImage(
                  height: ScreenUtil().setHeight(40),
                  imageUrl: ride.mapUrl ?? "",
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                  ),
                  placeholder: (context, url) => CircleAvatar(
                    backgroundColor: Styles.secondaryColor(),
                    child: Spinner(),
                  ),
                  errorWidget: (context, url, error) {
                    return Image(
                      image: AssetImage("lib/images/map.jpg"),
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
   String buttonTextKey;
   Ride ride;

   _panel(this.sc, this.buttonTextKey, this.ride);


   final _codeFormKey = GlobalKey<FormState>();
   TextEditingController seatsController = TextEditingController();
   TextEditingController luggageController = TextEditingController(text : "0");

   void seatsLuggagePopUp(Ride ride, BuildContext context) {
     var alertStyle = AlertStyle(
       animationType: AnimationType.grow,
       overlayColor: Colors.black45,
       isCloseButton: true,
       isOverlayTapDismiss: true,
       titleStyle: Styles.labelTextStyle(),
       descStyle: Styles.valueTextStyle(),
       animationDuration: Duration(milliseconds: 400),
     );
     Alert(
         context: context,
         style: alertStyle,
         title: Lang.getString(context, "Reserve_Seats_Luggage"),
         desc: Lang.getString(context, "Reserve"),
         content: Form(
           key: _codeFormKey,
           child: Column(
             children: [
               ResponsiveRow(
                 widgetRealtiveSize: 10,
                 children: [
                   TextFormField(
                     controller: seatsController,
                     validator: (value) {
                       String valid = Validation.validate(value, context);
                       if (valid != null) return valid;
                       return null;
                     },
                     keyboardType: TextInputType.number,
                     inputFormatters: [
                       FilteringTextInputFormatter.digitsOnly,
                       LengthLimitingTextInputFormatter(5),
                     ],
                     maxLengthEnforced: true,
                     decoration: InputDecoration(
                       labelText: Lang.getString(context, "Seats"),
                       hintText: "1",
                       labelStyle: Styles.labelTextStyle(),
                     ),
                   ),
                 ],
               ),
               ResponsiveRow(
                 widgetRealtiveSize: 10,
                 children: [
                   TextFormField(
                     controller: luggageController,
                     validator: (value) {
                       String valid = Validation.validate(value, context);
                       if (valid != null) return valid;
                       return null;
                     },
                     keyboardType: TextInputType.number,
                     inputFormatters: [
                       FilteringTextInputFormatter.digitsOnly,
                       LengthLimitingTextInputFormatter(5),
                     ],
                     maxLengthEnforced: true,
                     decoration: InputDecoration(
                       labelText: Lang.getString(context, "Luggage"),
                       hintText: "0",
                       labelStyle: Styles.labelTextStyle(),
                     ),
                   ),
                 ],
               ),
             ],
           ),
         ),
         buttons: [
           DialogButton(
             child: Text(Lang.getString(context, "Confirm"),
                 style: Styles.buttonTextStyle(),
                 overflow: TextOverflow.visible),
             color: Styles.primaryColor(),
             onPressed: () {
               if (_codeFormKey.currentState.validate()) {
                 int seats = int.parse(seatsController.text);
                 int luggage = int.parse(luggageController.text);
                 showDialog(
                   context: context,
                   barrierDismissible: false,
                   builder: (BuildContext context) {
                     return WillPopScope(
                       onWillPop: () async => false,
                       child: Center(
                         child: Spinner(),
                       ),
                     );
                   },
                 );
                 Request<Ride> req = ReserveSeat(
                     ride, App.user, seats, luggage);
                 req.send((r, status, reason) =>
                     response(ride, status, reason, context));
               }
             },
           ),
         ]).show();
   }

   void response(Ride r, int status, String reason, BuildContext context) {
     if (status == 200) {
       CustomToast().showSuccessToast(Lang.getString(context, "Ride_Reserved_Success"));
     } else {

       CustomToast().showErrorToast(Lang.getString(context, "Ride_Reserved_Failed"));
     }
     Navigator.popUntil(context, (route) => route.isFirst);
   }

   @override
   Widget build(BuildContext context) {
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
                   text_key: buttonTextKey,
                   onPressed: () {
                     seatsLuggagePopUp(ride, context);
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
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     _Title(text: Lang.getString(context, "From")),
                     _Title(text: Lang.getString(context, "To")),
                     _Title(text: Lang.getString(context, "Date")),
                   ],
                 ),
               ),
               Expanded(
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
                         DateFormat(App.dateFormat).format(ride.leavingDate),
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
           ResponsiveRow(children: [Text(ride.comment)]),
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
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     _Title(text: Lang.getString(context, "Available_Seats")),
                     _Title(text: Lang.getString(context, "Luggage")),
                     _Title(text: Lang.getString(context, "Stop_Duration")),
                     _Title(text: Lang.getString(context, "Price")),
                   ],
                 ),
               ),
               Expanded(
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
                         ride.stopTime.toString(),
                         maxLines: 1,
                         style: Styles.valueTextStyle(),
                         overflow: TextOverflow.clip,
                       ),
                     ),
                     ResponsiveWidget.fullWidth(
                       height: 40,
                       child: Text(
                         ride.price.toString() + ride.countryInformations.unit,
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
