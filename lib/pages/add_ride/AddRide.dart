import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/pages/BecomeDriver.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/DateTimePicker.dart';
import 'package:just_miles/utilities/FromToPicker.dart';
import 'package:just_miles/utilities/LocationFinder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Switcher.dart';

class AddRide extends StatefulWidget {
  Ride rideInfo;
  AddRide({this.rideInfo});
  @override
  _AddRideState createState() => _AddRideState();
}

class _AddRideState extends State<AddRide> {
  LocationEditingController fromController;
  LocationEditingController toController;
  DateTimeController dateTimeController;
  SwitcherController smokeController;
  SwitcherController acController;
  SwitcherController petsController;
  SwitcherController musicController;

  IconData smokeIcon = Icons.smoke_free;
  IconData acIcon = Icons.ac_unit;
  IconData petsIcon = Icons.pets;
  IconData musicIcon = Icons.music_off;

  String _fromError, _toError;
  Ride rideInfo = Ride();
  String _appBarTitleKey = "Add_Ride";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromController = LocationEditingController();
    toController = LocationEditingController();
    dateTimeController = DateTimeController(
      chosenDate: DateTime.now().add(Duration(minutes: 40)),
    );
    smokeController = SwitcherController();
    acController = SwitcherController();
    petsController = SwitcherController();
    musicController = SwitcherController();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        builder: (BuildContext context, bool isDriver, Widget child) {
          if (!isDriver) {
            return BecomeDriver();
          }
          return MainScaffold(
            appBar: MainAppBar(
              title: Lang.getString(context, _appBarTitleKey),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ResponsiveWidget.fullWidth(
                      height: 170,
                      child: FromToPicker(
                        fromController: fromController,
                        toController: toController,
                        fromError: _fromError,
                        toError: _toError,
                        canPickCurrLocation: false,
                      )),
                  VerticalSpacer(height: 30),
                  ResponsiveWidget(
                      width: 270,
                      height: 60,
                      child: DateTimePicker(
                        dateTimeController,
                      )),
                  VerticalSpacer(height: 15),
                  ResponsiveWidget(
                    width: 270,
                    height: 30,
                    child: Center(
                      child: Text(Lang.getString(context, "Rides_Permissions"),
                          style: Styles.labelTextStyle()),
                    ),
                  ),
                  VerticalSpacer(height: 15),
                  ResponsiveWidget.fullWidth(
                      height: 60,
                      child: Row(
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 4,
                            child: Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Icon(
                                    smokeIcon,
                                    color: smokeController.isOn
                                        ? Styles.primaryColor()
                                        : Styles.labelColor(),
                                  )),
                              Expanded(
                                flex: 2,
                                child: Switcher(
                                  isOn: smokeController.isOn,
                                  controller: smokeController,
                                  onChanged: (value) {
                                    setState(() {
                                      smokeIcon = value == true
                                          ? Icons.smoking_rooms
                                          : Icons.smoke_free;
                                    });
                                  },
                                ),
                              ),
                            ]),
                          ),
                          Spacer(),
                          Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Icon(
                                        petsIcon,
                                        color: petsController.isOn
                                            ? Styles.primaryColor()
                                            : Styles.labelColor(),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Switcher(
                                      isOn: petsController.isOn,
                                      controller: petsController,
                                      onChanged: (value) {
                                        setState(() {
                                          petsIcon = value == true
                                              ? Icons.pets
                                              : Icons.pets;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )),
                          Spacer(),
                        ],
                      )),
                  ResponsiveWidget.fullWidth(
                    height: 60,
                    child: Row(
                      children: [
                        Spacer(),
                        Expanded(
                          flex: 4,
                          child: Row(children: [
                            Expanded(
                                flex: 2,
                                child: Icon(
                                  musicIcon,
                                  color: musicController.isOn
                                      ? Styles.primaryColor()
                                      : Styles.labelColor(),
                                )),
                            Expanded(
                              flex: 2,
                              child: Switcher(
                                isOn: musicController.isOn,
                                controller: musicController,
                                onChanged: (value) {
                                  setState(() {
                                    musicIcon = value == true
                                        ? Icons.music_note
                                        : Icons.music_off;
                                  });
                                },
                              ),
                            ),
                          ]),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 5,
                                    child: Icon(
                                      acIcon,
                                      color: acController.isOn
                                          ? Styles.primaryColor()
                                          : Styles.labelColor(),
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "A/C ",
                                    style: acController.isOn
                                        ? Styles.subValueTextStyle(
                                            color: Styles.primaryColor())
                                        : Styles.subValueTextStyle(
                                            color: Styles.labelColor()),
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: Switcher(
                                    isOn: acController.isOn,
                                    controller: acController,
                                    onChanged: (value) {
                                      setState(() {
                                        acIcon = value == true
                                            ? Icons.ac_unit
                                            : Icons.ac_unit;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Spacer(),
                      ],
                    ),
                  ),
                  VerticalSpacer(height: 60),
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
                      textKey: "Next",
                      onPressed: () {
                        String _validateFrom =
                            fromController.validate(context, x: toController);
                        String _validateTo =
                            toController.validate(context, x: fromController);
                        _fromError = _validateFrom;
                        _toError = _validateTo;
                        setState(() {});
                        if (_validateFrom == null && _validateTo == null) {
                          if (dateTimeController.chosenDate.isBefore(
                              DateTime.now().add(Duration(minutes: 29)))) {
                            return CustomToast().showErrorToast(Lang.getString(
                                context, "Ride_Time_validation"));
                          }

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
                          DateTime date = dateTimeController.chosenDate;
                          bool isSmoke = smokeController.isOn;
                          bool isPets = petsController.isOn;
                          bool isAc = acController.isOn;
                          bool isMusic = musicController.isOn;

                          var rideDate = dateTimeController.chosenDate;
                          rideDate = rideDate.add(Duration(minutes: -20));
                          rideDate = DateTime.utc(
                              rideDate.year,
                              rideDate.month,
                              rideDate.day,
                              rideDate.hour,
                              rideDate.minute,
                              rideDate.second);
                          for (final item in App.person.upcomingRides) {
                            if (item == null || item.status == "CANCELED") {
                              continue;
                            }
                            var diff =
                                rideDate.difference(item.leavingDate).inMinutes;
                            if (rideDate.isAfter(item.leavingDate) &&
                                diff <= 0 &&
                                diff >= -20) {
                              return CustomToast().showErrorToast(
                                  Lang.getString(
                                      context, "Ride_compare_upcoming"));
                            }
                            if (rideDate.isBefore(item.leavingDate) &&
                                diff >= -40) {
                              return CustomToast().showErrorToast(
                                  Lang.getString(
                                      context, "Ride_compare_upcoming"));
                            }
                          }

                          rideInfo.user = App.user;

                          rideInfo.to = to;
                          rideInfo.from = from;
                          rideInfo.leavingDate = date;
                          rideInfo.smokingAllowed = isSmoke;
                          rideInfo.petsAllowed = isPets;
                          rideInfo.musicAllowed = isMusic;
                          rideInfo.acAllowed = isAc;
                          Navigator.of(context).pushNamed("/AddRidePage2",
                              arguments: [rideInfo, _appBarTitleKey]);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        valueListenable: App.isDriverNotifier);
  }
}
