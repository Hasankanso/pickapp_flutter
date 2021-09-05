import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class AddRidePage2 extends StatefulWidget {
  final Ride rideInfo;
  final String appBarTitleKey;

  const AddRidePage2({
    Key key,
    this.rideInfo,
    this.appBarTitleKey,
  }) : super(key: key);

  @override
  _AddRidePage2State createState() => _AddRidePage2State(rideInfo);
}

class _AddRidePage2State extends State<AddRidePage2> {
  final Ride rideInfo;
  final _formKey = GlobalKey<FormState>();

  _AddRidePage2State(this.rideInfo);

  bool stopOver = false;
  bool kidsSeat = false;
  final timeController = TextEditingController();
  final descController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rideInfo.kidSeat = kidsSeat;
    rideInfo.comment = descController.text;
    if (stopOver == true && timeController.text != "") {
      int time = int.parse(timeController.text);
      rideInfo.stopTime = time;
    } else {
      rideInfo.stopTime = 0;
    }

    descController.dispose();
    timeController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (rideInfo.kidSeat != null) kidsSeat = rideInfo.kidSeat;
    descController.text = rideInfo.comment;
    if (rideInfo.stopTime != null && rideInfo.stopTime != 0) {
      stopOver = true;
      timeController.text = rideInfo.stopTime.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, widget.appBarTitleKey),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              VerticalSpacer(
                height: 20,
              ),
              ResponsiveWidget.fullWidth(
                height: 50,
                child: Row(children: [
                  Spacer(),
                  Expanded(
                    flex: 6,
                    child: Text(
                      Lang.getString(context, "Do_You_Have_Kids_Seat"),
                      style: Styles.labelTextStyle(),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        value: kidsSeat,
                        onChanged: (bool newValue) {
                          setState(() {
                            kidsSeat = newValue;
                          });
                        },
                      )),
                  Spacer(),
                ]),
              ),
              VerticalSpacer(
                height: 20,
              ),
              ResponsiveWidget.fullWidth(
                height: 50,
                child: Row(children: [
                  Spacer(),
                  Expanded(
                    flex: 6,
                    child: Text(
                      Lang.getString(context, "Do_You_Want_To_Stop_Over"),
                      style: Styles.labelTextStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Checkbox(
                      value: stopOver,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      onChanged: (bool newValue) {
                        setState(() {
                          stopOver = newValue;
                        });
                      },
                    ),
                  ),
                  Spacer(),
                ]),
              ),
              VerticalSpacer(
                height: 20,
              ),
              Visibility(
                visible: stopOver,
                child: ResponsiveWidget.fullWidth(
                  height: 100,
                  child: Row(children: [
                    Spacer(),
                    Expanded(
                      flex: 6,
                      child: Text(
                        Lang.getString(context, "How_Much_Time_You_Need"),
                        style: Styles.labelTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: timeController,
                        minLines: 1,
                        textInputAction: TextInputAction.next,
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Min"),
                          labelStyle: Styles.labelTextStyle(),
                        ),
                        style: Styles.valueTextStyle(),
                        validator: (value) {
                          String valid = Validation.validate(value, context);

                          int time = int.tryParse(value);
                          if (valid != null)
                            return valid;
                          else if (time < 5) {
                            return Lang.getString(context, "Min_stop_time");
                          } else if (time > 30) {
                            return Lang.getString(context, "Max_stop_time");
                          } else
                            return null;
                        },
                      ),
                    ),
                    Spacer(),
                  ]),
                ),
              ),
              VerticalSpacer(
                height: 20,
              ),
              ResponsiveWidget(
                width: 270,
                height: 150,
                child: TextFormField(
                  controller: descController,
                  minLines: 4,
                  textInputAction: TextInputAction.done,
                  maxLines: 20,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(400),
                  ],
                  decoration: InputDecoration(
                    labelText: Lang.getString(context, "Description"),
                    labelStyle: Styles.labelTextStyle(),
                    hintStyle: Styles.labelTextStyle(),
                  ),
                  style: Styles.valueTextStyle(),
                  validator: (value) {
                    String valid = Validation.validate(value, context);
                    String alpha =
                        Validation.isAlphaNumericIgnoreSpaces(context, value);
                    String short = Validation.isShort(context, value, 25);

                    if (valid != null)
                      return valid;
                    else if (alpha != null)
                      return alpha;
                    else if (short != null)
                      return short;
                    else
                      return null;
                  },
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Spacer(
                      flex: 8,
                    ),
                    Expanded(
                      flex: 60,
                      child: MainNativeAd(),
                    ),
                    Spacer(
                      flex: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                  text_key: "Next",
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      rideInfo.kidSeat = kidsSeat;
                      rideInfo.comment = descController.text;
                      if (stopOver == true && timeController.text != "") {
                        int time = int.parse(timeController.text);
                        rideInfo.stopTime = time;
                      }
                      Navigator.of(context).pushNamed("/AddRidePage3",
                          arguments: [rideInfo, widget.appBarTitleKey]);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
