import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar extends StatefulWidget {
  Driver driver;
  AddCar({this.driver});

  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _brand = TextEditingController();
  TextEditingController _year = TextEditingController();
  MainImageController _imageController = MainImageController();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Car"),
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
                height: 110,
                child: Align(
                  alignment: Alignment.center,
                  child: MainImagePicker(
                    controller: _imageController,
                    isCarPicker: true,
                  ),
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: ResponsiveRow(
                  children: [
                    TextFormField(
                      controller: _name,
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
                  ],
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: ResponsiveRow(
                  children: [
                    TextFormField(
                      controller: _brand,
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
                  ],
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: ResponsiveRow(
                  children: [
                    TextFormField(
                      controller: _year,
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
                isRequest: false,
                text_key: "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_imageController.pickedImage == null) {
                      return CustomToast().showErrorToast(
                          Lang.getString(context, "Select_an_image"));
                    }
                    print(widget.driver);
                    if (widget.driver != null) {
                      widget.driver.cars = [
                        Car(
                          name: _name.text,
                          brand: _brand.text,
                          year: int.parse(_year.text),
                        )
                      ];
                      await widget.driver.cars[0]
                          .setPictureFile(_imageController.pickedImage);
                      Navigator.pushNamed(context, "/AddCar2Driver",
                          arguments: widget.driver);
                    } else {
                      print(22);
                      Car car = Car(
                        name: _name.text,
                        brand: _brand.text,
                        year: int.parse(_year.text),
                      );
                      await car.setPictureFile(_imageController.pickedImage);
                      Navigator.pushNamed(context, "/AddCar2", arguments: car);
                    }
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
