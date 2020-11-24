import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainRangeSlider.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Switcher.dart';

class AddRide extends StatefulWidget {
  @override
  _AddRideState createState() => _AddRideState();
}

class _AddRideState extends State<AddRide> {
  MainRangeSliderController rangeController = MainRangeSliderController();
  SwitcherController switcherController = SwitcherController();
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: Column(
        children: [
          Switcher(
            controller: switcherController,
            isOn: true,
          ),
          MainRangeSlider(
            min: 0,
            max: 100,
            minSelected: 40,
            maxSelected: 90,
            step: 5,
            controller: rangeController,
          ),
        ],
      ),
    );
  }
}
