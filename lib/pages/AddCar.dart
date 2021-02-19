import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/BrandAutocomplete.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddCar extends StatefulWidget {
  Driver driver;
  bool isForceRegister;
  User user;

  AddCar({this.driver, this.isForceRegister, this.user});

  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  TextEditingController _brand = TextEditingController();
  TextEditingController _year = TextEditingController();
  MainImageController _imageController = MainImageController();
  Car car = Car();
  ColorController _colorController = ColorController();
  Map<String, String> _carBrands = Map<String, String>();
  String _brandKey;

  @override
  void dispose() async {
    // TODO: implement dispose
    if (widget.driver != null) {
      if (widget.driver.cars == null || widget.driver.cars.length == 0) {
        widget.driver.cars = [car];
      }
      if (!Validation.isNullOrEmpty(_name.text))
        widget.driver.cars[0].name = _name.text;
      if (!Validation.isNullOrEmpty(_brand.text))
        widget.driver.cars[0].brand = _brand.text;
      if (!Validation.isNullOrEmpty(_year.text))
        widget.driver.cars[0].year = int.parse(_year.text);
      if (_imageController.pickedImage != null)
        widget.driver.cars[0].imageFile = _imageController.pickedImage;
      if (_colorController.pickedColor != null)
        widget.driver.cars[0].color = _colorController.pickedColor.value;
    } else if (widget.user != null) {
      if (widget.user.driver.cars == null ||
          widget.user.driver.cars.length == 0) {
        widget.user.driver.cars = [car];
      }
      if (!Validation.isNullOrEmpty(_name.text))
        widget.user.driver.cars[0].name = _name.text;
      if (!Validation.isNullOrEmpty(_brand.text))
        widget.user.driver.cars[0].brand = _brand.text;
      if (!Validation.isNullOrEmpty(_year.text))
        widget.user.driver.cars[0].year = int.parse(_year.text);
      if (_imageController.pickedImage != null) {
        widget.user.driver.cars[0].imageFile = _imageController.pickedImage;
      }
      if (_colorController.pickedColor != null)
        widget.user.driver.cars[0].color = _colorController.pickedColor.value;
    }
    _name.dispose();
    _year.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    for (final item in _carBrandsKeys) {
      _carBrands[item] = Lang.getString(context, item);
    }
    if (widget.driver != null) {
      if (widget.driver.cars != null) {
        if (!Validation.isNullOrEmpty(widget.driver.cars[0].name))
          _name.text = widget.driver.cars[0].name;
        if (!Validation.isNullOrEmpty(widget.driver.cars[0].brand))
          _brand.text = _carBrands[widget.driver.cars[0].brand];
        if (widget.driver.cars[0].year != null)
          _year.text = widget.driver.cars[0].year.toString();
        if (widget.driver.cars[0].imageFile != null)
          _imageController.pickedImage = widget.driver.cars[0].imageFile;
        if (widget.driver.cars[0].color != null)
          _colorController.pickedColor = Color(widget.driver.cars[0].color);
      } else {
        widget.driver.cars = [Car()];
      }
    } else if (widget.user != null) {
      if (widget.user.driver.cars != null) {
        if (!Validation.isNullOrEmpty(widget.user.driver.cars[0].name))
          _name.text = widget.user.driver.cars[0].name;
        if (!Validation.isNullOrEmpty(widget.user.driver.cars[0].brand))
          _brand.text = _carBrands[widget.user.driver.cars[0].brand];
        if (widget.user.driver.cars[0].year != null)
          _year.text = widget.user.driver.cars[0].year.toString();
        if (widget.user.driver.cars[0].imageFile != null)
          _imageController.pickedImage = widget.user.driver.cars[0].imageFile;
        if (widget.user.driver.cars[0].color != null)
          _colorController.pickedColor =
              Color(widget.user.driver.cars[0].color);
      } else {
        widget.user.driver.cars = [Car()];
      }
    }
  }

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
                    title: Lang.getString(context, "Car"),
                  ),
                ),
              ),
              ResponsiveWidget.fullWidth(
                height: 100,
                child: ResponsiveRow(
                  children: [
                    TextFormField(
                      controller: _brand,
                      style: Styles.valueTextStyle(),
                      textInputAction: TextInputAction.next,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      minLines: 1,
                      focusNode: FocusNode(),
                      readOnly: true,
                      onTap: () async {
                        List<String> _item = await showSearch(
                          context: context,
                          delegate: BrandAutocomplete(
                              context: context, carBrands: _carBrands),
                        );
                        if (_item != null) {
                          _brandKey = _item[0];
                          _brand.text = _item[1];
                        }
                      },
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Brand"),
                        labelStyle: Styles.labelTextStyle(),
                        hintStyle: Styles.labelTextStyle(),
                      ),
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
              ResponsiveWidget.fullWidth(
                height: 80,
                child: DifferentSizeResponsiveRow(children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 11,
                    child: Text(
                      Lang.getString(context, "Color"),
                      style: Styles.labelTextStyle(),
                    ),
                  ),
                  Spacer(
                    flex: 4,
                  ),
                  Expanded(
                    flex: 3,
                    child: ColorPicker(_colorController),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ]),
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
                  if (_validate()) {
                    if (_imageController.pickedImage == null) {
                      return CustomToast().showErrorToast(
                          Lang.getString(context, "Select_an_image"));
                    }
                    //becomedriver
                    if (widget.driver != null) {
                      if (widget.driver.cars != null &&
                          widget.driver.cars.length == 1) {
                        widget.driver.cars[0].name = _name.text;
                        widget.driver.cars[0].brand = _brandKey;
                        widget.driver.cars[0].year = int.parse(_year.text);
                        widget.driver.cars[0].color =
                            _colorController.pickedColor.value;
                      } else {
                        car.name = _name.text;
                        car.brand = _brandKey;
                        car.year = int.parse(_year.text);
                        car.color = _colorController.pickedColor.value;
                        widget.driver.cars = [car];
                      }
                      await widget.driver.cars[0]
                          .setPictureFile(_imageController.pickedImage);
                      Navigator.pushNamed(context, "/AddCar2Driver",
                          arguments: widget.driver);
                    } else if (widget.user != null) {
                      //register
                      if (widget.user.driver.cars != null &&
                          widget.user.driver.cars.length == 1) {
                        widget.user.driver.cars[0].name = _name.text;
                        widget.user.driver.cars[0].brand = _brandKey;
                        widget.user.driver.cars[0].year = int.parse(_year.text);
                        widget.user.driver.cars[0].color =
                            _colorController.pickedColor.value;
                      } else {
                        car.name = _name.text;
                        car.brand = _brandKey;
                        car.year = int.parse(_year.text);
                        car.color = _colorController.pickedColor.value;

                        widget.user.driver.cars = [car];
                      }
                      await widget.user.driver.cars[0]
                          .setPictureFile(_imageController.pickedImage);

                      Navigator.pushNamed(context, "/AddCar2Register",
                          arguments: [
                            widget.user,
                            widget.isForceRegister,
                          ]);
                    } else {
                      //add car
                      car.name = _name.text;
                      car.brand = _brandKey;
                      car.year = int.parse(_year.text);
                      car.color = _colorController.pickedColor.value;
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

  bool _brandValidate() {
    String val = _brand.text;
    String valid = Validation.validate(val, context);
    if (valid != null) {
      //_brandErrorText = valid;
      return false;
    } else if (val.length < 2) {
      //_brandErrorText = Validation.invalid(context);
      return false;
    }

    return true;
  }

  bool _validate() {
    bool form = _formKey.currentState.validate();
    bool bra = _brandValidate();
    return (bra == true && form == true);
  }

  List<String> _carBrandsKeys = [
    "Acura",
    "Alfa_Romeo",
    "Aston_Martin",
    "Audi",
    "Bentley",
    "BMW",
    "Bugatti",
    "Buick",
    "Cadillac",
    "Chevrolet",
    "Chrysler",
    "Citroen",
    "Dodge",
    "Ferrari",
    "Fiat",
    "Ford",
    "Geely",
    "General_Motors",
    "GMC",
    "Honda",
    "Hyundai",
    "Infiniti",
    "Jaguar",
    "Jeep",
    "Kia",
    "Koenigsegg",
    "Lamborghini",
    "Land_Rover",
    "Lexus",
    "Maserati",
    "Mazda",
    "McLaren",
    "Mercedes-Benz",
    "Mini",
    "Mitsubishi",
    "Nissan",
    "Pagani",
    "Peugeot",
    "Porsche",
    "Ram",
    "Renault",
    "Rolls_Royce",
    "Saab",
    "Subaru",
    "Suzuki",
    "Tata_Motors",
    "Tesla",
    "Toyota",
    "Volkswagen",
    "Volvo",
  ];
}
