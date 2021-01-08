import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/AddCar.dart';
import 'package:pickapp/requests/BecomeDriverRequest.dart';
import 'package:pickapp/requests/ForceRegisterPerson.dart';
import 'package:pickapp/requests/RegisterPerson.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class AddCar3 extends StatefulWidget {
  Driver driver;
  Car car;
  bool isForceRegister;
  User user;
  String idToken;

  AddCar3(
      {this.driver, this.car, this.isForceRegister, this.user, this.idToken});

  @override
  _AddCar3State createState() => _AddCar3State();
}

class _AddCar3State extends State<AddCar3> {
  int _maxSeats, _maxLuggage;
  ColorController _colorController = ColorController();
  NumberController _seatsController = NumberController();
  NumberController _luggageController = NumberController();
  String _btnText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int _type;
    if (widget.driver != null) {
      _btnText = "Become_a_driver";
      _type = widget.driver.cars[0].type;
    } else if (widget.car != null) {
      _type = widget.car.type;
      _btnText = "Add_car";
    } else if (widget.user != null) {
      _btnText = "Register";
      _type = widget.user.driver.cars[0].type;
    }
    if (_type == 0) {
      _maxSeats = 4;
      _maxLuggage = 3;
    } else if (_type == 1) {
      _maxSeats = 6;
      _maxLuggage = 4;
    } else if (_type == 2) {
      _maxSeats = 4;
      _maxLuggage = 3;
    } else if (_type == 3) {
      _maxSeats = 13;
      _maxLuggage = 7;
    }
    if (widget.car != null) {
      if (widget.car.maxSeats != null)
        _seatsController.chosenNumber = widget.car.maxSeats;
      if (widget.car.maxLuggage != null)
        _luggageController.chosenNumber = widget.car.maxLuggage;
      if (widget.car.color != null)
        _colorController.pickedColor = Color(widget.car.color);
    } else if (widget.driver != null) {
      if (widget.driver.cars[0].maxSeats != null)
        _seatsController.chosenNumber = widget.driver.cars[0].maxSeats;
      if (widget.driver.cars[0].maxLuggage != null)
        _luggageController.chosenNumber = widget.driver.cars[0].maxLuggage;
      if (widget.driver.cars[0].color != null)
        _colorController.pickedColor = Color(widget.driver.cars[0].color);
    } else if (widget.user != null) {
      if (widget.user.driver.cars[0].maxSeats != null)
        _seatsController.chosenNumber = widget.user.driver.cars[0].maxSeats;
      if (widget.user.driver.cars[0].maxLuggage != null)
        _luggageController.chosenNumber = widget.user.driver.cars[0].maxLuggage;
      if (widget.user.driver.cars[0].color != null)
        _colorController.pickedColor = Color(widget.user.driver.cars[0].color);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (widget.car != null) {
      if (_seatsController.chosenNumber != null)
        widget.car.maxSeats = _seatsController.chosenNumber;
      if (_luggageController.chosenNumber != null)
        widget.car.maxLuggage = _luggageController.chosenNumber;
      if (_colorController.pickedColor != null)
        widget.car.color = _colorController.pickedColor.value;
    } else if (widget.driver != null) {
      if (_seatsController.chosenNumber != null)
        widget.driver.cars[0].maxSeats = _seatsController.chosenNumber;
      if (_luggageController.chosenNumber != null)
        widget.driver.cars[0].maxLuggage = _luggageController.chosenNumber;
      if (_colorController.pickedColor != null)
        widget.driver.cars[0].color = _colorController.pickedColor.value;
    } else if (widget.user != null) {
      if (_seatsController.chosenNumber != null)
        widget.user.driver.cars[0].maxSeats = _seatsController.chosenNumber;
      if (_luggageController.chosenNumber != null)
        widget.user.driver.cars[0].maxLuggage = _luggageController.chosenNumber;
      if (_colorController.pickedColor != null)
        widget.user.driver.cars[0].color = _colorController.pickedColor.value;
    }
    super.dispose();
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
                flex: 2,
              ),
              Expanded(
                flex: 3,
                child: ColorPicker(_colorController),
              ),
              Spacer(
                flex: 4,
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
                      return WillPopScope(
                        onWillPop: () async => false,
                        child: Center(
                          child: Spinner(),
                        ),
                      );
                    },
                  );
                  if (widget.driver != null) {
                    _becomeDriverRequest();
                  } else if (widget.car != null) {
                    _addCarRequest();
                  } else if (widget.user != null) {
                    _registerRequest();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _registerRequest() {
    widget.user.driver.cars[0].maxLuggage = _luggageController.chosenNumber;
    widget.user.driver.cars[0].maxSeats = _seatsController.chosenNumber;
    widget.user.driver.cars[0].color = _colorController.pickedColor.value;

    Request<User> registerRequest;

    if (!widget.isForceRegister) {
      registerRequest = RegisterPerson(widget.user, widget.idToken);
    } else {
      registerRequest = ForceRegisterPerson(widget.idToken, widget.user);
    }
    registerRequest.send(_registerResponse);
  }

  _addCarRequest() {
    widget.car.maxLuggage = _luggageController.chosenNumber;
    widget.car.maxSeats = _seatsController.chosenNumber;
    widget.car.color = _colorController.pickedColor.value;
    Request<List<Car>> request = AddCar(widget.car);
    request.send(_addCarResponse);
  }

  _becomeDriverRequest() {
    if (App.calculateAge(App.person.birthday) <
        App.person.countryInformations.drivingAge) {
      Navigator.pop(context);
      return CustomToast().showErrorToast(Lang.getString(context, "Under_age"));
    }
    widget.driver.cars[0].maxLuggage = _luggageController.chosenNumber;
    widget.driver.cars[0].maxSeats = _seatsController.chosenNumber;
    widget.driver.cars[0].color = _colorController.pickedColor.value;
    Request<Driver> request = BecomeDriverRequest(widget.driver);
    request.send(_becomeDriverResponse);
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user = u;
      await Cache.setUserCache(u);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      CustomToast().showSuccessToast(
          Lang.getString(context, "Email_confirmation_pending"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
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

      await Hive.openBox('regions');
      var regionsBox = Hive.box("regions");
      if (regionsBox.containsKey(0)) {
        await regionsBox.put(0, p1.regions);
      } else {
        await regionsBox.add(p1.regions);
      }

      regionsBox.close();
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
