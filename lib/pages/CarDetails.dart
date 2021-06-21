import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/requests/EditCar.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class CarDetails extends StatefulWidget {
  Car car;
  CarDetails({this.car});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final _formKey = GlobalKey<FormState>();
  ColorController _colorController = ColorController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  MainImageController _imageController = MainImageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nameController.text = widget.car.name;
    _yearController.text = widget.car.year.toString();
    _colorController = ColorController(pickedColor: widget.car.color);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Car_Details"),
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
                    title: Lang.getString(context, "Car"),
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
                  ],
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 105,
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
                  ],
                ),
              ),
              VerticalSpacer(
                height: 14,
              ),
              ResponsiveWidget.fullWidth(
                height: 40,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                      flex: 100,
                      child: DifferentSizeResponsiveRow(
                        children: [
                          Spacer(
                            flex: 8,
                          ),
                          Expanded(
                            flex: 60,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text(
                                    Lang.getString(context, "Color"),
                                    style: Styles.labelTextStyle(),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ColorPicker(_colorController),
                                ),
                              ],
                            ),
                          ),
                          Spacer(
                            flex: 8,
                          )
                        ],
                      ),
                    ),
                    Spacer(
                      flex: 1,
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
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Edit",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    for (var item in App.person.upcomingRides) {
                      if (item.car.id == widget.car.id) {
                        return CustomToast().showErrorToast(
                            Lang.getString(context, "Delete_car_message"));
                      }
                    }
                    /* if (widget.car.updated != null &&
                        widget.car.updated.difference(DateTime.now()).inDays >
                            -30) {
                      return CustomToast().showErrorToast(
                          Lang.getString(context, "Car_edit_time"));
                    }*/
                    Car c = widget.car;
                    Car car = Car(
                        color: c.color,
                        id: c.id,
                        name: c.name,
                        updated: c.updated,
                        maxLuggage: c.maxLuggage,
                        year: c.year,
                        carPictureUrl: c.carPictureUrl,
                        type: c.type,
                        brand: c.brand,
                        maxSeats: c.maxSeats);
                    car.name = _nameController.text;
                    car.year = int.parse(_yearController.text);
                    car.color = _colorController.pickedColor.value;
                    if (_imageController.pickedImage != null) {
                      await car.setPictureFile(_imageController.pickedImage);
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
                    Request<Car> request = EditCar(car);
                    request.send(_editCarResponse);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _editCarResponse(Car p1, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user.driver.cars.remove(p1);
      App.user.driver.cars.add(p1);
      await Cache.setUser(App.user);
      App.updateProfile.value = !App.updateProfile.value;

      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
