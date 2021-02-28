import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Alert.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/requests/BroadCastAlert.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/DateTimePicker.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddAlert extends StatefulWidget {
  @override
  _AddAlertState createState() => _AddAlertState();
}

class _AddAlertState extends State<AddAlert> {
  final _formKey = GlobalKey<FormState>();
  LocationEditingController fromController = LocationEditingController();
  LocationEditingController toController = LocationEditingController();
  DateTimeController dateTimeController = DateTimeController();
  NumberController personsController = NumberController();
  NumberController luggageController = NumberController();
  final commentController = TextEditingController();
  final priceController = TextEditingController();

  String _fromError, _toError;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Broadcast_Alert"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(height: 10),
            ResponsiveWidget.fullWidth(
                height: 170,
                child: FromToPicker(
                  fromController: fromController,
                  toController: toController,
                  fromError: _fromError,
                  toError: _toError,
                )),
            VerticalSpacer(height: 33),
            ResponsiveWidget.fullWidth(
                height: 140,
                child: DateTimePicker(
                  dateTimeController,
                )),
            VerticalSpacer(
              height: 25,
            ),
            ResponsiveWidget.fullWidth(
                height: 40,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                        flex: 100,
                        child:
                            NumberPicker(personsController, "Persons", 1, 8)),
                    Spacer(
                      flex: 1,
                    )
                  ],
                )),
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
                height: 40,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                        flex: 100,
                        child:
                            NumberPicker(luggageController, "Luggage", 1, 8)),
                    Spacer(
                      flex: 1,
                    )
                  ],
                )),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  ResponsiveWidget.fullWidth(
                    height: 100,
                    child: Row(
                      children: [
                        Spacer(
                          flex: 2,
                        ),
                        Expanded(
                            flex: 6,
                            child: Text(
                              Lang.getString(context, "Price"),
                              style: Styles.labelTextStyle(),
                            )),
                        Spacer(
                          flex: 2,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            minLines: 1,
                            textInputAction: TextInputAction.done,
                            maxLines: 1,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(8),
                            ],
                            decoration: InputDecoration(
                              labelText: Lang.getString(
                                  context, App.person.countryInformations.unit),
                              labelStyle: Styles.labelTextStyle(),
                              hintStyle: Styles.labelTextStyle(),
                            ),
                            style: Styles.valueTextStyle(),
                            validator: (value) {
                              String valid =
                                  Validation.validate(value, context);
                              Validation.isNullOrEmpty(value);
                              int price = int.tryParse(value);
                              if (valid != null)
                                return valid;
                              else if (price <
                                  App.person.countryInformations.minPrice) {
                                Lang.getString(context, "Min_stop_time");
                                return Lang.getString(
                                        context, "Minimum_short") +
                                    " " +
                                    App.person.countryInformations.minPrice
                                        .toString();
                              } else if (price >
                                  App.person.countryInformations.maxPrice) {
                                return Lang.getString(
                                        context, "Maximum_short") +
                                    " " +
                                    App.person.countryInformations.maxPrice
                                        .toString();
                              } else
                                return null;
                            },
                          ),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 128,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Spacer(
                          flex: 15,
                        ),
                        Expanded(
                          flex: 100,
                          child: TextFormField(
                            controller: commentController,
                            minLines: 4,
                            textInputAction: TextInputAction.done,
                            maxLines: 20,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(400),
                            ],
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "Comment"),
                              labelStyle: Styles.labelTextStyle(),
                              hintStyle: Styles.labelTextStyle(),
                            ),
                            style: Styles.valueTextStyle(),
                            validator: (value) {
                              String valid =
                                  Validation.validate(value, context);
                              String alpha =
                                  Validation.isAlphaNumericIgnoreSpaces(
                                      context, value);
                              String short =
                                  Validation.isShort(context, value, 25);

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
                        Spacer(
                          flex: 15,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            VerticalSpacer(
              height: 20,
            ),
          ],
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
                text_key: "Broadcast",
                isRequest: true,
                onPressed: () async {
                  String _validateFrom =
                      fromController.validate(context, x: toController);
                  String _validateTo =
                      toController.validate(context, x: fromController);
                  _fromError = _validateFrom;
                  _toError = _validateTo;
                  setState(() {});
                  if (_validateFrom != null || _validateTo != null) {
                  } else {
                    //todo validation for date time
                    //if(dateTimeController.startDateController.chosenDate.difference(dateTimeController.endDateController.chosenDate).inDays>10)
                    if (_formKey.currentState.validate()) {
                      MainLocation to = MainLocation(
                          name: toController.description,
                          latitude: toController.location.lat,
                          longitude: toController.location.lng,
                          placeId: toController.placeId);
                      MainLocation from = MainLocation(
                          name: fromController.description,
                          latitude: fromController.location.lat,
                          longitude: fromController.location.lng,
                          placeId: fromController.placeId);
                      Alert _alert = Alert(
                        to: to,
                        from: from,
                        price: double.parse(priceController.text),
                        comment: commentController.text,
                        maxLuggage: luggageController.chosenNumber,
                        maxSeats: personsController.chosenNumber,
                        leavingDate: dateTimeController.chosenDate,
                      );
                      Request<String> request = BroadCastAlert(_alert);
                      await request.send(_response);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _response(String p1, int code, String p3) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(p3);
    } else {
      CustomToast().showErrorToast(Lang.getString(context, p1));
      Navigator.pop(context);
    }
  }
}
