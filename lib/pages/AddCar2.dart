import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/items/CarTypeItem.dart';
import 'package:pickapp/requests/AddCar.dart';
import 'package:pickapp/requests/BecomeDriverRequest.dart';
import 'package:pickapp/requests/ForceRegisterPerson.dart';
import 'package:pickapp/requests/RegisterPerson.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class AddCar2 extends StatefulWidget {
  Driver driver;
  Car car;
  bool isForceRegister;
  User user;

  AddCar2({this.driver, this.car, this.isForceRegister, this.user});

  @override
  _AddCar2State createState() => _AddCar2State();
}

class _AddCar2State extends State<AddCar2> {
  int _type;
  List<bool> _typesBool = [false, false, false, false];
  List<String> _typesNames;
  int _maxSeats, _maxLuggage;
  String _btnText;

  selectType(int index) {
    setState(() {
      _typesBool = [false, false, false, false];
      _typesBool[index] = true;
      _type = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_type != null) {
      if (widget.car != null)
        widget.car.type = _type;
      else if (widget.driver != null)
        widget.driver.cars[0].type = _type;
      else if (widget.user != null) widget.user.driver.cars[0].type = _type;
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.driver != null) {
      _btnText = "Become_a_driver";
    } else if (widget.car != null) {
      _btnText = "Add_car";
    } else if (widget.user != null) {
      _btnText = "Register";
    }
    if ((widget.car != null && widget.car.type != null))
      selectType(widget.car.type);
    else if (widget.driver != null && widget.driver.cars[0].type != null) {
      selectType(widget.driver.cars[0].type);
    } else if (widget.user != null && widget.user.driver.cars[0].type != null) {
      selectType(widget.user.driver.cars[0].type);
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _typesNames = [
      Lang.getString(context, "Sedan"),
      Lang.getString(context, "SUV"),
      Lang.getString(context, "Hatchback"),
      Lang.getString(context, "Van")
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Car"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VerticalSpacer(
            height: 20,
          ),
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
                CarTypeItem(_typesBool[0], _typesNames[0], 'lib/images/car2', selectType, 0)
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[1], _typesNames[1], 'lib/images/car3', selectType, 1),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[2], _typesNames[2], 'lib/images/car1', selectType, 2),
              ],
            ),
          ),
          ResponsiveWidget.fullWidth(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CarTypeItem(_typesBool[3], _typesNames[3], 'lib/images/car4', selectType, 3),
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
                text_key: _btnText,
                onPressed: () {
                  if (_type == null) {
                    return CustomToast().showErrorToast(Lang.getString(context, "Select_type"));
                  }
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
                  if (widget.driver != null) {
                    widget.driver.cars[0].type = _type;
                    widget.driver.cars[0].maxSeats = _maxSeats;
                    widget.driver.cars[0].maxLuggage = _maxLuggage;

                    _becomeDriverRequest();
                  } else if (widget.car != null) {
                    widget.car.type = _type;
                    widget.car.maxSeats = _maxSeats;
                    widget.car.maxLuggage = _maxLuggage;
                    _addCarRequest();
                  } else if (widget.user != null) {
                    widget.user.driver.cars[0].type = _type;
                    widget.user.driver.cars[0].maxSeats = _maxSeats;
                    widget.user.driver.cars[0].maxLuggage = _maxLuggage;
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
    Request<User> registerRequest;

    //get device token before registering
    FirebaseMessaging.instance.getToken().then((value) => {
          widget.user.person.deviceToken = value,
          if (!widget.isForceRegister)
            {registerRequest = RegisterPerson(widget.user)}
          else
            {registerRequest = ForceRegisterPerson(widget.user)},
          registerRequest.send(_registerResponse)
        });
  }

  _addCarRequest() {
    Request<List<Car>> request = AddCar(widget.car);
    request.send(_addCarResponse);
  }

  _becomeDriverRequest() {
    if (App.calculateAge(App.person.birthday) < App.person.countryInformations.drivingAge) {
      Navigator.pop(context);
      return CustomToast().showErrorToast(Lang.getString(context, "Under_age"));
    }
    Request<Driver> request = BecomeDriverRequest(widget.driver);
    request.send(_becomeDriverResponse);
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user = u;
      await Cache.setUser(u);
      App.setCountriesComponent([App.person.countryInformations.countryComponent]);
      App.isDriverNotifier.value = true;

      App.isLoggedInNotifier.value = true;

      CustomToast().showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      CustomToast().showSuccessToast(Lang.getString(context, "Email_confirmation_pending"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  _becomeDriverResponse(Driver p1, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user.driver = p1;

      await Cache.setUser(App.user);

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
      App.user.driver.cars = p1;
      await Cache.setUser(App.user);
      App.updateProfile.value = true;

      CustomToast().showSuccessToast(Lang.getString(context, "Successfully_added!"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
