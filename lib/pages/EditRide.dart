import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/EditRideRequest.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class EditRide extends StatelessWidget {
  final Ride ride;
  EditRide(this.ride);

  final _formKey = GlobalKey<FormState>();
  final NumberController personController = NumberController();
  final NumberController luggageController = NumberController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(
          context,
          "Edit_Ride",
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              VerticalSpacer(
                height: 30,
              ),
              ResponsiveWidget.fullWidth(
                  height: 40,
                  child: NumberPicker(
                    personController,
                    "Seats",
                    ride.availableSeats,
                    ride.car.maxSeats,
                  )),
              VerticalSpacer(
                height: 50,
              ),
              ResponsiveWidget.fullWidth(
                  height: 40,
                  child: NumberPicker(
                    luggageController,
                    "Luggage",
                    ride.availableLuggages,
                    ride.car.maxLuggage,
                  )),
              VerticalSpacer(
                height: 30,
              ),
              DifferentSizeResponsiveRow(children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    Lang.getString(context, "Description"),
                    style: Styles.labelTextStyle(),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ]),
              VerticalSpacer(
                height: 10,
              ),
              DifferentSizeResponsiveRow(children: [
                Spacer(
                  flex: 1,
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    ride.comment,
                    style: Styles.valueTextStyle(),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ]),
              ResponsiveWidget.fullWidth(
                height: 128,
                child: DifferentSizeResponsiveRow(children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 19,
                    child: TextFormField(
                      controller: descController,
                      minLines: 5,
                      textInputAction: TextInputAction.done,
                      maxLines: 20,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(400 - ride.comment.length),
                      ],
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Additional_description"),
                        labelStyle: Styles.labelTextStyle(),
                        hintStyle: Styles.labelTextStyle(),
                      ),
                      style: Styles.valueTextStyle(),
                      validator: (value) {
                        String valid = Validation.validate(value, context);
                        String alpha = Validation.isAlphaNumericIgnoreSpaces(context, value);

                        if (valid != null)
                          return valid;
                        else if (alpha != null)
                          return alpha;
                        else
                          return null;
                      },
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ]),
              ),
              VerticalSpacer(
                height: 20,
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
                text_key: "Edit_Ride",
                isRequest: true,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (ride.leavingDate.compareTo(DateTime.now()) < 0) {
                      return CustomToast()
                          .showErrorToast(Lang.getString(context, "Ride_already_started"));
                    }
                    ride.availableSeats = personController.chosenNumber;
                    ride.availableLuggages = luggageController.chosenNumber;
                    ride.comment = ride.comment + "\n" + descController.text;
                    Request<Ride> request = EditRideRequest(ride);
                    await request.send((result, code, message) =>
                        _editRideResponse(result, code, message, context));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _editRideResponse(Ride result, int code, String message, context) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      App.user.person.upcomingRides.remove(result);
      App.user.person.upcomingRides.add(result);
      Cache.setUser(App.user);
      Navigator.popUntil(context, (route) => route.isFirst);
      App.updateUpcomingRide.value = !App.updateUpcomingRide.value;

      CustomToast().showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }
}
