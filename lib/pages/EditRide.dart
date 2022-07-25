import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/ads/Ads.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/repository/user/user_repository.dart';
import 'package:just_miles/requests/EditRideRequest.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/NumberPicker.dart';
import 'package:just_miles/utilities/Responsive.dart';

class EditRide extends StatefulWidget {
  final Ride ride;

  EditRide(this.ride);

  @override
  State<EditRide> createState() => _EditRideState();
}

class _EditRideState extends State<EditRide> {
  final _formKey = GlobalKey<FormState>();

  final NumberController personController = NumberController();

  final NumberController luggageController = NumberController();

  final descController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadAd();
  }

  _loadAd() async {
    await Ads.loadRewardedAd();
  }

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
                    widget.ride.maxSeats,
                    widget.ride.car.maxSeats,
                  )),
              VerticalSpacer(
                height: 50,
              ),
              ResponsiveWidget.fullWidth(
                  height: 40,
                  child: NumberPicker(
                    luggageController,
                    "Luggage",
                    widget.ride.maxLuggage,
                    widget.ride.car.maxLuggage,
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
                    widget.ride.comment,
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
                            399 - widget.ride.comment.length),
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
                isRequest: false,
                onPressed: () async {
                  Ride r = widget.ride.copy();
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
                    r.comment =
                        widget.ride.comment + "\n" + descController.text;

                    await Ads.showRewardedAd(() async {
                      Request<Ride> request = EditRideRequest(r);
                      await request.send((result, code, message) =>
                          _editRideResponse(result, code, message, context));
                    }, context);
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
      Navigator.pop(context);
      return;
    }
    App.user.person.upcomingRides.remove(ride);
    App.user.person.upcomingRides.add(ride);

    UserRepository().updateUser(App.user);

    Navigator.popUntil(context, (route) => route.isFirst);
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;

    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
  }
}
