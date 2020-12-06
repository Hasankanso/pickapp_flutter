import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/DateTimeRangePicker.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Switcher.dart';

class AddRide extends StatefulWidget {
  @override
  _AddRideState createState() => _AddRideState();
}

class _AddRideState extends State<AddRide> {
  LocationEditingController fromController = LocationEditingController();
  LocationEditingController toController = LocationEditingController();
  DateTimeRangeController dateTimeController = DateTimeRangeController();
  SwitcherController smokeController = SwitcherController();
  SwitcherController acController = SwitcherController();
  SwitcherController petsController = SwitcherController();
  SwitcherController musicController = SwitcherController();

  IconData smokeIcon = Icons.smoke_free;
  IconData acIcon = Icons.ac_unit;
  IconData petsIcon = Icons.pets;
  IconData musicIcon = Icons.music_off;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Add_Ride"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ResponsiveWidget.fullWidth(
                  height: 130,
                  child: FromToPicker(
                      fromController: fromController,
                      toController: toController)),
              VerticalSpacer(height: 30),
              ResponsiveWidget.fullWidth(
                  height: 80, child: DateTimeRangePicker(dateTimeController)),
              VerticalSpacer(height: 10),
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
                  height: 120,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 4,
                            child: Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Icon(
                                    smokeIcon,
                                    color: Styles.primaryColor(),
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
                                        color: Styles.primaryColor(),
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
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Expanded(
                            flex: 4,
                            child: Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Icon(
                                    musicIcon,
                                    color: Styles.primaryColor(),
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
                                        color: Styles.primaryColor(),
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
                      )
                    ],
                  )),
              VerticalSpacer(height: 60),
              ResponsiveWidget(
                width: 270,
                height: 50,
                child: MainButton(
                  text_key: "Next",
                  onPressed: () {
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
                    DateTime date =
                        dateTimeController.startDateController.chosenDate;
                    bool isSmoke = smokeController.isOn;
                    bool isPets = petsController.isOn;
                    bool isAc = acController.isOn;
                    bool isMusic = musicController.isOn;
                    Ride rideInfo = new Ride();
                    rideInfo.to = to;
                    rideInfo.from = from;
                    rideInfo.leavingDate = date;
                    rideInfo.smokingAllowed = isSmoke;
                    rideInfo.petsAllowed = isPets;
                    rideInfo.musicAllowed = isMusic;
                    rideInfo.acAllowed = isAc;
                    Navigator.of(context)
                        .pushNamed("/AddRidePage2", arguments: rideInfo);
                  },
                ),
              ),
            ],
          ),
        ));
  }
}