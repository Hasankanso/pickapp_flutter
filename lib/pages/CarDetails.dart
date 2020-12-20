import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/DeleteCar.dart';
import 'package:pickapp/requests/EditCar.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CarDetails extends StatefulWidget {
  Car car;
  CarDetails({this.car});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final _formKey = GlobalKey<FormState>();
  int _type;
  int _maxSeats, _maxLuggage;
  ColorController _colorController = ColorController();
  NumberController _seatsController = NumberController();
  NumberController _luggageController = NumberController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  List<String> _typeItems;
  MainImageController _imageController = MainImageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _type = widget.car.type;
    _nameController.text = widget.car.name;
    _brandController.text = widget.car.brand;
    _yearController.text = widget.car.year.toString();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _typeItems = <String>[
      Lang.getString(context, "Sedan"),
      Lang.getString(context, "SUV"),
      Lang.getString(context, "Hatchback"),
      Lang.getString(context, "Van")
    ];
    _setMaxSeatsLuggage();
  }

  _setMaxSeatsLuggage() {
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
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Car details",
        actions: [
          App.driver.cars.length != 1
              ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: Styles.largeIconSize(),
                  ),
                  tooltip: Lang.getString(context, "Delete"),
                  onPressed: () {
                    PopUp.areYouSure(
                            Lang.getString(context, "Yes"),
                            Lang.getString(context, "No"),
                            Lang.getString(context, "Car_delete_message"),
                            Lang.getString(context, "Warning!"),
                            Colors.red,
                            (bool) => bool ? _deleteCarRequest() : null,
                            interest: false)
                        .confirmationPopup(context);
                  },
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              VerticalSpacer(
                height: 20,
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: Align(
                  alignment: Alignment.center,
                  child: MainImagePicker(
                    isCarPicker: true,
                    imageUrl: widget.car.carPictureUrl,
                    controller: _imageController,
                  ),
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _nameController,
                        minLines: 1,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Name"),
                          hintText: Lang.getString(context, "Car_name_hint"),
                          labelStyle: Styles.labelTextStyle(),
                          hintStyle: Styles.labelTextStyle(),
                        ),
                        style: Styles.valueTextStyle(),
                        validator: (value) {
                          String valid = Validation.validate(value, context);
                          if (valid != null)
                            return valid;
                          else if (value.length < 2)
                            return Validation.invalid(context);
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _brandController,
                        minLines: 1,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Brand"),
                          hintText: Lang.getString(context, "Car_brand_hint"),
                          labelStyle: Styles.labelTextStyle(),
                          hintStyle: Styles.labelTextStyle(),
                        ),
                        style: Styles.valueTextStyle(),
                        validator: (value) {
                          String valid = Validation.validate(value, context);

                          if (valid != null)
                            return valid;
                          else if (value.length < 2)
                            return Validation.invalid(context);
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _yearController,
                        minLines: 1,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Year"),
                          hintText: 2015.toString(),
                          labelStyle: Styles.labelTextStyle(),
                          hintStyle: Styles.labelTextStyle(),
                        ),
                        style: Styles.valueTextStyle(),
                        validator: (value) {
                          String valid = Validation.validate(value, context);
                          if (valid != null)
                            return valid;
                          else if (value.length != 4 ||
                              int.parse(value) > DateTime.now().year ||
                              int.parse(value) < (DateTime.now().year - 120))
                            return Validation.invalid(context);
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Type"),
                        ),
                        isExpanded: true,
                        value: _typeItems[widget.car.type],
                        validator: (val) {
                          String valid = Validation.validate(val, context);
                          if (valid != null) return valid;
                          return null;
                        },
                        onChanged: (String newValue) {
                          setState(() {
                            _type = _typeItems.indexOf(newValue);
                            _setMaxSeatsLuggage();
                          });
                        },
                        items: _typeItems
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalSpacer(
                height: 10,
              ),
              ResponsiveWidget.fullWidth(
                height: 40,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                        flex: 100,
                        child: NumberPicker(
                            _seatsController, "Seats", 1, _maxSeats)),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
              VerticalSpacer(
                height: 10,
              ),
              ResponsiveWidget.fullWidth(
                  height: 40,
                  child: DifferentSizeResponsiveRow(
                    children: [
                      Expanded(
                        flex: 100,
                        child: NumberPicker(
                            _luggageController, "Luggage", 1, _maxLuggage),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                    ],
                  )),
              VerticalSpacer(
                height: 10,
              ),
              ResponsiveWidget.fullWidth(
                height: 60,
                child: DifferentSizeResponsiveRow(
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(children: [
          ResponsiveRow(
            children: [
              ResponsiveWidget(
                width: 170,
                height: 50,
                child: MainButton(
                  text_key: "View",
                  isRequest: true,
                  onPressed: () async {},
                ),
              ),
              ResponsiveWidget(
                width: 170,
                height: 50,
                child: MainButton(
                  text_key: "Edit",
                  isRequest: true,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      Car car = widget.car;
                      car.name = _nameController.text;
                      car.brand = _brandController.text;
                      car.year = int.parse(_yearController.text);
                      car.color = _colorController.pickedColor.value;
                      car.type = _type;
                      car.maxSeats = _seatsController.chosenNumber;
                      car.maxLuggage = _luggageController.chosenNumber;
                      if (_imageController.pickedImage != null) {
                        await car.setPictureFile(_imageController.pickedImage);
                      }
                      Request<List<Car>> request = EditCar(widget.car);
                      await request.send(_editCarResponse);
                    }
                  },
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  _editCarResponse(List<Car> p1, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
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
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }

  _deleteCarRequest() async {
    Request<List<Car>> request = DeleteCar(widget.car);
    await request.send(_deleteCarResponse);
  }

  _deleteCarResponse(List<Car> p1, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
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
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
