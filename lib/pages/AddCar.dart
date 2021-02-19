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
  ColorController _colorController = ColorController();
  Map<String, String> _carBrands = Map<String, String>();
  String _brandKey;
  Car car = Car();

  @override
  void dispose() async {
    // TODO: implement dispose
    if (widget.driver != null) {
      if (widget.driver.cars == null || widget.driver.cars.length == 0) {
        widget.driver.cars = [this.car];
      }
      var carJ = widget.driver.cars[0];

      if (!Validation.isNullOrEmpty(_name.text)) carJ.name = _name.text;
      if (!Validation.isNullOrEmpty(_brand.text)) carJ.brand = _brandKey;
      if (!Validation.isNullOrEmpty(_year.text))
        carJ.year = int.parse(_year.text);
      if (_imageController.pickedImage != null)
        carJ.imageFile = _imageController.pickedImage;
      if (_colorController.pickedColor != null)
        carJ.color = _colorController.pickedColor.value;
    } else if (widget.user != null) {
      if (widget.user.driver.cars == null ||
          widget.user.driver.cars.length == 0) {
        widget.user.driver.cars = [this.car];
      }
      var carD = widget.user.driver.cars[0];

      if (!Validation.isNullOrEmpty(_name.text)) carD.name = _name.text;
      if (!Validation.isNullOrEmpty(_brand.text)) carD.brand = _brandKey;
      if (!Validation.isNullOrEmpty(_year.text))
        carD.year = int.parse(_year.text);
      if (_imageController.pickedImage != null) {
        carD.imageFile = _imageController.pickedImage;
      }
      if (_colorController.pickedColor != null)
        carD.color = _colorController.pickedColor.value;
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
        var carJ = widget.driver.cars[0];

        if (!Validation.isNullOrEmpty(carJ.name)) _name.text = carJ.name;
        if (!Validation.isNullOrEmpty(carJ.brand)) {
          _brandKey = carJ.brand;
          _brand.text = _carBrands[carJ.brand];
        }
        if (carJ.year != null) _year.text = carJ.year.toString();
        if (carJ.imageFile != null)
          _imageController.pickedImage = carJ.imageFile;
        if (carJ.color != null)
          _colorController.pickedColor = Color(carJ.color);
      } else {
        widget.driver.cars = [Car()];
      }
    } else if (widget.user != null) {
      if (widget.user.driver.cars != null) {
        var carD = widget.user.driver.cars[0];

        if (!Validation.isNullOrEmpty(carD.name)) _name.text = carD.name;
        if (!Validation.isNullOrEmpty(carD.brand)) {
          _brandKey = carD.brand;
          _brand.text = _carBrands[carD.brand];
        }
        if (carD.year != null) _year.text = carD.year.toString();
        if (carD.imageFile != null)
          _imageController.pickedImage = carD.imageFile;
        if (carD.color != null)
          _colorController.pickedColor = Color(carD.color);
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
                        var carJ = widget.driver.cars[0];
                        carJ.name = _name.text;
                        carJ.brand = _brandKey;
                        carJ.year = int.parse(_year.text);
                        carJ.color = _colorController.pickedColor.value;
                      } else {
                        this.car.name = _name.text;
                        this.car.brand = _brandKey;
                        this.car.year = int.parse(_year.text);
                        this.car.color = _colorController.pickedColor.value;
                        widget.driver.cars = [this.car];
                      }
                      await widget.driver.cars[0]
                          .setPictureFile(_imageController.pickedImage);
                      Navigator.pushNamed(context, "/AddCar2Driver",
                          arguments: widget.driver);
                    } else if (widget.user != null) {
                      //register
                      if (widget.user.driver.cars != null &&
                          widget.user.driver.cars.length == 1) {
                        var carD = widget.user.driver.cars[0];
                        carD.name = _name.text;
                        carD.brand = _brandKey;
                        carD.year = int.parse(_year.text);
                        carD.color = _colorController.pickedColor.value;
                      } else {
                        this.car.name = _name.text;
                        this.car.brand = _brandKey;
                        this.car.year = int.parse(_year.text);
                        this.car.color = _colorController.pickedColor.value;

                        widget.user.driver.cars = [this.car];
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
                      this.car.name = _name.text;
                      this.car.brand = _brandKey;
                      this.car.year = int.parse(_year.text);
                      this.car.color = _colorController.pickedColor.value;
                      await this
                          .car
                          .setPictureFile(_imageController.pickedImage);
                      Navigator.pushNamed(context, "/AddCar2",
                          arguments: this.car);
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
