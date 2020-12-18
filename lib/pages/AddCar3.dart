import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/AddCar.dart';
import 'package:pickapp/requests/BecomeDriverRequest.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar3 extends StatefulWidget {
  Object object;
  AddCar3({this.object});

  @override
  _AddCar3State createState() => _AddCar3State();
}

class _AddCar3State extends State<AddCar3> {
  Driver driver;
  Car car;
  int _maxSeats, _maxLuggage;
  ColorController _colorController = ColorController();
  NumberController _seatsController = NumberController();
  NumberController _luggageController = NumberController();
  var _btnText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.object.runtimeType == Driver) {
      driver = widget.object as Driver;
      _btnText = "Become_a_driver";
    } else if (widget.object.runtimeType == Car) {
      car = widget.object as Car;
      _btnText = "Add_car";
    }
  }

  @override
  void didChangeDependencies() {
    String _type;
    if (driver != null) {
      _type = driver.cars[0].type;
    } else if (car != null) {
      _type = car.type;
    }
    if (_type == Lang.getString(context, "Sedan")) {
      _maxSeats = 4;
      _maxLuggage = 3;
    } else if (_type == Lang.getString(context, "SUV")) {
      _maxSeats = 6;
      _maxLuggage = 4;
    } else if (_type == Lang.getString(context, "Hatchback")) {
      _maxSeats = 4;
      _maxLuggage = 3;
    } else if (_type == Lang.getString(context, "Van")) {
      _maxSeats = 13;
      _maxLuggage = 7;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Car"),
      ),
      body: Column(
        children: [
          VerticalSpacer(
            height: 30,
          ),
          ResponsiveWidget.fullWidth(
            height: 60,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                    flex: 20,
                    child:
                        NumberPicker(_seatsController, "Seats", 1, _maxSeats)),
              ],
            ),
          ),
          VerticalSpacer(
            height: 30,
          ),
          ResponsiveWidget.fullWidth(
            height: 60,
            child: DifferentSizeResponsiveRow(
              children: [
                Expanded(
                    flex: 20,
                    child: NumberPicker(
                        _luggageController, "Luggage", 1, _maxLuggage)),
              ],
            ),
          ),
          VerticalSpacer(
            height: 30,
          ),
          ResponsiveWidget.fullWidth(
            height: 60,
            child: DifferentSizeResponsiveRow(children: [
              Spacer(
                flex: 2,
              ),
              Expanded(
                flex: 9,
                child: Text(
                  Lang.getString(context, "Color"),
                  style: Styles.labelTextStyle(),
                ),
              ),
              Spacer(
                flex: 1,
              ),
              Expanded(
                flex: 5,
                child: ColorPicker(_colorController),
              ),
              Spacer(
                flex: 3,
              ),
            ]),
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
                text_key: _btnText,
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  );
                  if (driver != null) {
                    _becomeDriverRequest();
                  } else if (car != null) {
                    _addCarRequest();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addCarRequest() {
    car.maxLuggage = _luggageController.chosenNumber;
    car.maxSeats = _seatsController.chosenNumber;
    car.color = _colorController.pickedColor.value;
    Request<List<Car>> request = AddCar(car);
    request.send(_addCarResponse);
  }

  _becomeDriverRequest() {
    driver.cars[0].maxLuggage = _luggageController.chosenNumber;
    driver.cars[0].maxSeats = _seatsController.chosenNumber;
    driver.cars[0].color = _colorController.pickedColor.value;
    Request<Driver> request = BecomeDriverRequest(driver);
    request.send(_becomeDriverResponse);
  }

  _becomeDriverResponse(Driver p1, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      final userBox = Hive.box("user");
      User cacheUser = App.user;
      Person cachePerson = App.person;
      cachePerson.rates = null;
      cacheUser.driver = p1;
      cacheUser.person = cachePerson;

      await userBox.put(0, cacheUser);

      App.user.driver = p1;
      App.isDriverNotifier.value = true;
      CustomToast().showSuccessToast(Lang.getString(context, "Now_driver"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  _addCarResponse(List<Car> p1, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      final userBox = Hive.box("user");
      User cacheUser = App.user;
      Person cachePerson = App.person;
      cachePerson.rates = null;
      cacheUser.driver = App.driver;
      cacheUser.driver.cars = p1;
      cacheUser.person = cachePerson;

      await userBox.put(0, cacheUser);

      App.user.driver.cars = p1;
      App.isDriverNotifier.notifyListeners();

      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_added!"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
