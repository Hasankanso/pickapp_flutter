import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/DateTimeRangePicker.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
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
  NumberController numberController = NumberController();
  SwitcherController switcherController = SwitcherController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Lang.getString(context, "Add_Ride")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ResponsiveWidget.fullWidth(
                  height: 130,
                  child: FromToPicker(
                      fromController: fromController, toController: toController)),
              VerticalSpacer(height: 30),
              ResponsiveWidget.fullWidth(
                  height: 80, child: DateTimeRangePicker(dateTimeController)),
              VerticalSpacer(height: 10),
              ResponsiveWidget(
                width: 270,
                height: 30,
                child: Center(
                  child: Text("Rides Permissions :",
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
                          Expanded(
                              flex: 1,
                              child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: Row(
                            children:[
                              Expanded(
                                  flex:2,
                                  child: Icon(Icons.smoke_free,color: Styles.primaryColor(),)
                              ),
                              Expanded(
                                flex:2,
                                child: Switcher(
                                  isOn: false,
                                  controller: switcherController,
                                ),
                              ),
                            ]
                          ),
                          ),
                           Expanded(
                               flex: 1,
                               child: SizedBox()),
                         Expanded(
                             flex: 4,
                             child: Row(
                           children: [
                             Expanded(
                                 flex:2,
                                 child: Icon(Icons.pets,color: Styles.primaryColor(),)
                             ),
                             Expanded(
                               flex:2,
                               child: Switcher(
                                 isOn: false,
                                 controller: switcherController,
                               ),
                             ),
                           ],
                         )
                         ),
                          Expanded(
                              flex: 1,
                              child: SizedBox()),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: SizedBox()),
                          Expanded(
                            flex: 4,
                            child: Row(
                                children:[
                                  Expanded(
                                      flex:2,
                                      child: Icon(Icons.music_off,color: Styles.primaryColor(),)
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: Switcher(
                                      isOn: false,
                                      controller: switcherController,
                                    ),
                                  ),
                                ]
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: SizedBox()),
                          Expanded(
                              flex: 4,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex:2,
                                      child: Icon(Icons.hot_tub,color: Styles.primaryColor(),)
                                  ),
                                  Expanded(
                                    flex:2,
                                    child: Switcher(
                                      isOn: false,
                                      controller: switcherController,
                                    ),
                                  ),
                                ],
                              )
                          ),
                          Expanded(
                              flex: 1,
                              child: SizedBox()),
                        ],
                      )

                    ],
                  )
              ),
              ResponsiveWidget(
                height: 100,
                width: 100,
                child: Center(child: TextField(
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                  keyboardType: TextInputType.number,
                  maxLines: 1,

                ))
                ,
              ),
              VerticalSpacer(height: 30),
              ResponsiveWidget(
                width: 270,
                height: 53,
                child: MainButton(
                  text_key: "Next",
                  onPressed: () {
                    Navigator.of(context).pushNamed("/AddRidePage2");

                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
