import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/Car.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/items/CarTileDropDown.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainExpansionTile.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/NumberPicker.dart';
import 'package:just_miles/utilities/Responsive.dart';

class AddRidePage3 extends StatefulWidget {
  final Ride rideInfo;
  final String appBarTitleKey;
  const AddRidePage3({
    Key key,
    this.rideInfo,
    this.appBarTitleKey,
  }) : super(key: key);

  @override
  _AddRidePage3State createState() => _AddRidePage3State(rideInfo);
}

class _AddRidePage3State extends State<AddRidePage3>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Ride rideInfo;
  NumberController personController = NumberController();
  NumberController luggageController = NumberController();
  final priceController = TextEditingController();
  String selectedCar;
  bool valueSelected = false;
  Car car;

  _AddRidePage3State(this.rideInfo);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (rideInfo.price != null)
      priceController.text = rideInfo.price.toString();
    if (rideInfo.car != null) {
      Future.delayed(Duration.zero, () {
        selectedCar = Lang.getString(context, rideInfo.car.brand) +
            " " +
            rideInfo.car.name;
        car = rideInfo.car;
        valueSelected = true;
        personController = NumberController(
          chosenNumber: rideInfo.availableSeats == null
              ? car == null
                  ? null
                  : car.maxSeats
              : rideInfo.availableSeats,
        );
        luggageController = NumberController(
          chosenNumber: rideInfo.availableLuggages == null
              ? car == null
                  ? null
                  : 0
              : rideInfo.availableLuggages,
        );
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (car == null) selectedCar = Lang.getString(context, "Choose_car");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    rideInfo.price = int.tryParse(priceController.text);

    if (car != null) {
      rideInfo.car = car;
      rideInfo.availableSeats = personController.chosenNumber;
      rideInfo.availableLuggages = luggageController.chosenNumber;
    }

    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, widget.appBarTitleKey),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                VerticalSpacer(
                  height: 20,
                ),
                InkWell(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: MainExpansionTile(
                            height: 70,

                            title: Text(
                              selectedCar,
                              style: valueSelected
                                  ? Styles.valueTextStyle(
                                      color: Styles.primaryColor())
                                  : Styles.labelTextStyle(),
                            ),
                            children: App.driver.cars.map((Car c) {
                              return CarTileDropDown(
                                  carName: Lang.getString(context, c.brand) +
                                      ", " +
                                      c.name,
                                  car: c,
                                  a: () {
                                    selectedCar =
                                        Lang.getString(context, c.brand) +
                                            ", " +
                                            c.name;
                                    car = c;
                                    valueSelected = true;
                                    personController = NumberController(
                                      chosenNumber: car.maxSeats,
                                    );
                                    luggageController = NumberController(
                                      chosenNumber: 0,
                                    );
                                    setState(() {});
                                  });
                            }).toList(growable: true),

                            //  getCar(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                VerticalSpacer(
                  height: 50,
                ),
                ResponsiveWidget.fullWidth(
                    height: 40,
                    child: NumberPicker(
                      personController,
                      "Seats",
                      1,
                      car == null ? null : car.maxSeats,
                      disabled: !valueSelected,
                    )),
                VerticalSpacer(
                  height: 50,
                ),
                ResponsiveWidget.fullWidth(
                    height: 40,
                    child: NumberPicker(
                      luggageController,
                      "Luggage",
                      0,
                      car == null ? null : car.maxLuggage,
                      disabled: !valueSelected,
                    )),
                VerticalSpacer(
                  height: 50,
                ),
                ResponsiveWidget.fullWidth(
                  height: 100,
                  child: Row(
                    children: [
                      Spacer(),
                      Expanded(
                          flex: 3,
                          child: Text(
                            Lang.getString(context, "Price"),
                            style: Styles.labelTextStyle(),
                          )),
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: priceController,
                          minLines: 1,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          decoration: InputDecoration(
                            labelText: Lang.getString(
                                context, rideInfo.countryInformations.unit),
                            labelStyle: Styles.labelTextStyle(),
                            hintStyle: Styles.labelTextStyle(),
                          ),
                          style: Styles.valueTextStyle(),
                          validator: (value) {
                            String valid = Validation.validate(value, context);
                            Validation.isNullOrEmpty(value);
                            int price = int.tryParse(value);
                            if (valid != null)
                              return valid;
                            else if (price <
                                rideInfo.countryInformations.minPrice) {
                              Lang.getString(context, "Min_stop_time");
                              return Lang.getString(context, "Minimum_short") +
                                  " " +
                                  rideInfo.countryInformations.minPrice
                                      .toString();
                            } else if (price >
                                rideInfo.countryInformations.maxPrice) {
                              return Lang.getString(context, "Maximum_short") +
                                  " " +
                                  rideInfo.countryInformations.maxPrice
                                      .toString();
                            } else
                              return null;
                          },
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
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
                textKey: "Next",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (valueSelected) {
                      rideInfo.availableSeats = personController.chosenNumber;
                      rideInfo.availableLuggages =
                          luggageController.chosenNumber;
                      rideInfo.car = car;
                      int price = int.parse(priceController.text);
                      rideInfo.price = price;
                      Navigator.of(context).pushNamed("/AddRidePage4",
                          arguments: [rideInfo, widget.appBarTitleKey]);
                    } else
                      CustomToast().showErrorToast(
                          Lang.getString(context, "Select_car"));
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
