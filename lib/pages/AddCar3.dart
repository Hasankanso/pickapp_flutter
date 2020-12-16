import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar3 extends StatefulWidget {
  @override
  _AddCar3State createState() => _AddCar3State();
}

class _AddCar3State extends State<AddCar3> {
  ColorController _colorController = ColorController();
  NumberController personController = NumberController();
  NumberController luggageController = NumberController();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Add Car", //Lang.getString(context, "Become_a_driver"),
      ),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
            height: 60,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                    flex: 20,
                    child: NumberPicker(personController, "Persons", 1, 8)),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 60,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                    flex: 20,
                    child: NumberPicker(luggageController, "Luggage", 1, 8)),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 60,
            child: DifferentSizeResponsiveRow(children: [
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 10,
                child: Text(
                  "Color",
                  style: Styles.labelTextStyle(),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 6,
                child: ColorPicker(_colorController),
              ),
              Spacer(
                flex: 2,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
