import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/requests/EditRideRequest.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/NumberPicker.dart';
import 'package:just_miles/utilities/Responsive.dart';

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
                        LengthLimitingTextInputFormatter(
                            399 - ride.comment.length),
                      ],
                      decoration: InputDecoration(
                        labelText:
                            Lang.getString(context, "Additional_description"),
                        labelStyle: Styles.labelTextStyle(),
                        hintStyle: Styles.labelTextStyle(),
                      ),
                      style: Styles.valueTextStyle(),
                      validator: (value) {
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
                textKey: "Edit_Ride",
                isRequest: true,
                onPressed: () async {
                  Ride r = ride.copy();
                  if (_formKey.currentState.validate()) {
                    if (r.leavingDate.compareTo(DateTime.now()) < 0) {
                      return CustomToast().showErrorToast(
                          Lang.getString(context, "Ride_already_started"));
                    }
                    r.availableSeats +=
                        (personController.chosenNumber - r.maxSeats);
                    r.availableLuggage +=
                        (luggageController.chosenNumber - r.maxLuggage);
                    r.maxSeats = personController.chosenNumber;
                    r.maxLuggage = luggageController.chosenNumber;
                    r.comment = ride.comment + "\n" + descController.text;
                    Request<Ride> request = EditRideRequest(r);
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

  _editRideResponse(Ride ride, int code, String message, context) {
    if (App.handleErrors(context, code, message)) {
      return;
    }
    App.user.person.upcomingRides.remove(ride);
    App.user.person.upcomingRides.add(ride);
    Cache.setUser(App.user);
    Navigator.popUntil(context, (route) => route.isFirst);
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;

    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
  }
}
