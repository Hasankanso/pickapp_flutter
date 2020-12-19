import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/ColorPicker.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class CarDetails extends StatefulWidget {
  Car car;
  CarDetails({this.car});

  @override
  _CarDetailsState createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  String _type;
  int _maxSeats, _maxLuggage;
  ColorController _colorController = ColorController();
  NumberController _seatsController = NumberController();
  NumberController _luggageController = NumberController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _brandController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  List<String> _typeItems;

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
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Car details",
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 120,
              child: DifferentSizeResponsiveRow(
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: widget.car.carPictureUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(200.0))),
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Image(
                            image: imageProvider,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(
                        backgroundColor: Styles.primaryColor(),
                      ),
                      errorWidget: (context, url, error) {
                        return Image(
                          image: AssetImage("lib/images/car.png"),
                        );
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
                        labelText: Lang.getString(context, "Country"),
                      ),
                      isExpanded: true,
                      value: '$_type',
                      validator: (val) {
                        String valid = Validation.validate(val, context);
                        if (valid != null) return valid;
                        return null;
                      },
                      onChanged: (String newValue) {
                        setState(() {
                          _type = newValue;
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
                      flex: 50,
                      child: NumberPicker(
                          _seatsController, "Seats", 1, _maxSeats)),
                  Spacer(
                    flex: 10,
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
                      flex: 20,
                      child: NumberPicker(
                          _luggageController, "Luggage", 1, _maxLuggage),
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
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(children: [
          ResponsiveRow(
            children: [
              ResponsiveWidget(
                width: 170,
                height: 50,
                child: MainButton(
                  text_key: "Search",
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
                  onPressed: () async {},
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
