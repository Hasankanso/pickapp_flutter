import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/pages/BecomeDriver.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/DateTimePicker.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Switcher.dart';

class AddRide extends StatefulWidget {
  Ride rideInfo;
  bool isEditRide;
  AddRide({this.rideInfo, this.isEditRide = false});
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
    if (!widget.isEditRide) {
      fromController = LocationEditingController();
      toController = LocationEditingController();
      dateTimeController = DateTimeController(
        chosenDate: DateTime.now().add(Duration(minutes: 40)),
      );
      smokeController = SwitcherController();
      acController = SwitcherController();
      petsController = SwitcherController();
      musicController = SwitcherController();
    } else {
      //for edit ride
      _appBarTitleKey = "Edit_Ride";
      var from = widget.rideInfo.from;
      var to = widget.rideInfo.to;
      fromController = LocationEditingController(
          description: from.name,
          placeId: from.placeId,
          location: Location(from.latitude, from.longitude));
      toController = LocationEditingController(
          description: to.name,
          placeId: to.placeId,
          location: Location(to.latitude, to.longitude));
      dateTimeController = DateTimeController(
        chosenDate: widget.rideInfo.leavingDate,
      );
      var music, ac, pets, smoke;
      smoke = widget.rideInfo.smokingAllowed;
      ac = widget.rideInfo.acAllowed;
      music = widget.rideInfo.musicAllowed;
      pets = widget.rideInfo.petsAllowed;
      smokeController = SwitcherController(isOn: smoke);
      acController = SwitcherController(isOn: ac);
      petsController = SwitcherController(isOn: pets);
      musicController = SwitcherController(isOn: music);
      smokeIcon = smoke == true ? Icons.smoking_rooms : Icons.smoke_free;
      petsIcon = pets == true ? Icons.pets : Icons.pets;
      musicIcon = music == true ? Icons.music_note : Icons.music_off;
      acIcon = ac == true ? Icons.ac_unit : Icons.ac_unit;
    }
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
                                    flex: 2,
                                    child: Icon(
                                      acIcon,
                                      color: acController.isOn
                                          ? Styles.primaryColor()
                                          : Styles.labelColor(),
                                    )),
                                Expanded(
                                  flex: 2,
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
                      text_key: "Next",
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
                          if (!widget.isEditRide) {
                            for (final item in App.person.upcomingRides) {
                              var diff = rideDate
                                  .difference(item.leavingDate)
                                  .inMinutes;
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
                          } else {
                            //edit ride
                            for (final item in App.person.upcomingRides) {
                              if (item.id != widget.rideInfo.id) {
                                var diff = rideDate
                                    .difference(item.leavingDate)
                                    .inMinutes;
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
                            }
                            widget.rideInfo.user = App.user;

                            widget.rideInfo.to = to;
                            widget.rideInfo.from = from;
                            widget.rideInfo.leavingDate = date;
                            widget.rideInfo.smokingAllowed = isSmoke;
                            widget.rideInfo.petsAllowed = isPets;
                            widget.rideInfo.musicAllowed = isMusic;
                            widget.rideInfo.acAllowed = isAc;
                            Navigator.of(context).pushNamed("/EditRidePage2",
                                arguments: [widget.rideInfo, _appBarTitleKey]);
                          }
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
