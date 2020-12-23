import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'file:///C:/Users/Ali/Desktop/pickApp_Flutter/pickapp_flutter/lib/items/CarTileDropDown.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainExpansionTile.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddRidePage3 extends StatefulWidget {
  final Ride rideInfo;

  const AddRidePage3({Key key, this.rideInfo}) : super(key: key);

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
  String selectedCar = "Choose car";
  bool valueSelected = false;
  Car car;

  _AddRidePage3State(this.rideInfo);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
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
                  child:
                  Row(
                    children: [
                      Expanded(
                        child: MainExpansionTile(
                          height: 70,
                          leading: Icon(
                            Icons.local_taxi_outlined,
                            size: Styles.mediumIconSize(),
                            color: valueSelected?Styles.primaryColor():Colors.grey,
                          ),
                          title: Text(
                            selectedCar,
                            style: valueSelected
                                ? Styles.valueTextStyle(
                              color: Styles.primaryColor()
                            )
                                : Styles.labelTextStyle(),

                          ),
                          children: App.driver.cars.map((Car c) {
                            return CarTileDropDown(
                                carName: c.brand +
                                    " / " +
                                    c.name,
                                car: c,
                                a: () {
                                  selectedCar = c.brand +
                                      " / " +
                                      c.name;
                                  car = c;
                                  valueSelected = true;
                                  setState(() {});
                                });
                          }).toList(growable: true),

                          //  getCar(),

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
                      1,
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
                            LengthLimitingTextInputFormatter(8),
                          ],
                          decoration: InputDecoration(
                            labelText: Lang.getString(context, "LBP"),
                            labelStyle: Styles.labelTextStyle(),
                            hintStyle: Styles.labelTextStyle(),
                          ),
                          style: Styles.valueTextStyle(),
                          validator: (value) {
                            String valid = Validation.validate(value, context);
                            Validation.isNullOrEmpty(value);
                            if (valid != null)
                              return valid;
                            else
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
                text_key: "Next",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    if (valueSelected) {
                      int seats = personController.chosenNumber;
                      int luggage = luggageController.chosenNumber;
                      rideInfo.availableSeats = seats;
                      rideInfo.availableLuggages = luggage;
                      rideInfo.car = App.user.driver.cars[0];
                      rideInfo.car = car;
                      int price = int.parse(priceController.text);
                      rideInfo.price = price;
                      Navigator.of(context)
                          .pushNamed("/AddRidePage4", arguments: rideInfo);
                    } else
                      CustomToast().showErrorToast(Lang.getString(context, "Select_car"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCar() {
    for (int i = 0; i < App.user.driver.cars.length; i++) {
      return CarTileDropDown(
          carName: App.user.driver.cars[i].brand +
              " / " +
              App.user.driver.cars[i].name,
          car: App.user.driver.cars[i],
          a: () {
            selectedCar = App.user.driver.cars[i].brand +
                " / " +
                App.user.driver.cars[i].name;
            car = App.user.driver.cars[i];
            valueSelected = true;
            setState(() {});
          });
    }
  }
}
