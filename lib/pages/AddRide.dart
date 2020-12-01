import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
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
  SwitcherController smoke = SwitcherController();
  SwitcherController ac = SwitcherController();
  SwitcherController pets = SwitcherController();
  SwitcherController music = SwitcherController();

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
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Icon(
                                    Icons.smoke_free,
                                    color: Styles.primaryColor(),
                                  )),
                              Expanded(
                                flex: 2,
                                child: Switcher(
                                  isOn: false,
                                  controller: smoke,
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
                                        Icons.pets,
                                        color: Styles.primaryColor(),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Switcher(
                                      isOn: false,
                                      controller: pets,
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(flex: 1, child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: Row(children: [
                              Expanded(
                                  flex: 2,
                                  child: Icon(
                                    Icons.music_off,
                                    color: Styles.primaryColor(),
                                  )),
                              Expanded(
                                flex: 2,
                                child: Switcher(
                                  isOn: false,
                                  controller: music,
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
                                        Icons.hot_tub,
                                        color: Styles.primaryColor(),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Switcher(
                                      isOn: false,
                                      controller: ac,
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(flex: 1, child: SizedBox()),
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
                    // MainLocation to = MainLocation(
                    //     name: toController.description,
                    //     latitude: toController.location.lat,
                    //     longitude: toController.location.lng,
                    //     placeId: toController.placeId);
                    // MainLocation from = MainLocation(
                    //     name: fromController.description,
                    //     latitude: fromController.location.lat,
                    //     longitude: fromController.location.lng,
                    //     placeId: fromController.placeId);
                    // DateTime date =
                    //     dateTimeController.startDateController.chosenDate;
                    // bool isSmoke = smoke.isOn;
                    // bool isPets = pets.isOn;
                    // bool isAc = ac.isOn;
                    // bool isMusic = music.isOn;
                    List<Object> dynamicList=new List();
                    String a="Ali";
                    dynamicList.add(a);
                    Navigator.of(context).pushNamed("/AddRidePage2",arguments:dynamicList );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
