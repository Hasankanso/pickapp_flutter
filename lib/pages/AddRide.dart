import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/DateTimeRangePicker.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainRangeSlider.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
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
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(flex: 1, child: Icon(Icons.location_on_outlined)),
                  Flexible(
                    flex: 8,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(labelText: "From"),
                    ),
                  ),
                  Expanded(flex: 1, child: Icon(Icons.swap_calls))
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(flex: 1, child: Icon(Icons.location_on)),
                  Flexible(
                    flex: 8,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(labelText: "To"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: DateTimeRangePicker(dateTimeController),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: NumberPicker(numberController, "Person", 1, 9, 1),
                        ),
                        Expanded(
                          flex: 1,
                          child: NumberPicker(numberController, "Luggage", 1, 9, 1),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 2,
                          child: Text("Smoking"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Switcher(
                            isOn: false,
                            controller: switcherController,
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 2,
                          child: Text("Pets"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Switcher(
                            isOn: false,
                            controller: switcherController,
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 2,
                          child: Text("Ac"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Switcher(
                            isOn: false,
                            controller: switcherController,
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                        Expanded(
                          flex: 2,
                          child: Text("Music"),
                        ),
                        Expanded(
                          flex: 2,
                          child: Switcher(
                            isOn: false,
                            controller: switcherController,
                          ),
                        ),
                        Expanded(flex: 1, child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Flexible(
                    flex: 5,
                    child: TextField(
                      expands: true,
                      maxLines: null,
                      decoration: InputDecoration(labelText: "Description"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),

                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text("click"),
                      textColor: Styles.primaryColor(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
