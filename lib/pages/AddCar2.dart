import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/items/CarTypeItem.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar2 extends StatefulWidget {
  Object object;
  AddCar2({this.object});
  @override
  _AddCar2State createState() => _AddCar2State();
}

class _AddCar2State extends State<AddCar2> {
  Driver driver;
  Car car;

  String _type;
  List<bool> _typesBool = [false, false, false, false];
  List<String> _typesNames;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.object.runtimeType == Driver) {
      driver = widget.object as Driver;
    } else if (widget.object.runtimeType == Car) {
      car = widget.object as Car;
    }
  }

  selectType(int index) {
    setState(() {
      _typesBool = [false, false, false, false];
      _typesBool[index] = true;
      _type = _typesNames[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_typesNames == null) {
      _typesNames = [
        Lang.getString(context, "Sedan"),
        Lang.getString(context, "SUV"),
        Lang.getString(context, "Hatchback"),
        Lang.getString(context, "Van")
      ];
    }

    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Car"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ResponsiveWidget.fullWidth(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Lang.getString(context, "Select_car_type:"),
                  style: Styles.labelTextStyle(),
                ),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[0], _typesNames[0], 'lib/images/car2',
                    selectType, 0)
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[1], _typesNames[1], 'lib/images/car3',
                    selectType, 1),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[2], _typesNames[2], 'lib/images/car1',
                    selectType, 2),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[3], _typesNames[3], 'lib/images/car4',
                    selectType, 3),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: false,
                text_key: "Next",
                onPressed: () {
                  if (_type == null) {
                    return CustomToast()
                        .showErrorToast(Lang.getString(context, "Select_type"));
                  }
                  if (driver != null) {
                    driver.cars[0].type = _type;
                    Navigator.pushNamed(
                      context,
                      "/AddCar3",
                      arguments: driver,
                    );
                  } else if (car != null) {
                    car.type = _type;
                    Navigator.pushNamed(
                      context,
                      "/AddCar3",
                      arguments: car,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
