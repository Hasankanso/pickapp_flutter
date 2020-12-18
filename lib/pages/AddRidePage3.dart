import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Car.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/Buttons.dart';
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
  bool valueSelected=false;
  Car car;

  _AddRidePage3State(this.rideInfo);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: GestureDetector(
        onTap: (){
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
                AnimatedSize(
                  curve: Curves.fastLinearToSlowEaseIn,
                  duration: Duration(milliseconds: 10),
                  vsync: this,
                  child: MainExpansionTile(
                    height: 70,
                    leading: Icon(
                      Icons.local_taxi_outlined,
                      size: Styles.mediumIconSize(),
                      color: Colors.grey,
                    ),
                    title: Text(
                      selectedCar,
                      style: valueSelected?Styles.valueTextStyle():Styles.labelTextStyle(),
                    ),
                    children: [
                      getCar(),
                    ],
                  ),
                ),
                VerticalSpacer(
                  height: 50,
                ),
                ResponsiveWidget.fullWidth(
                    height: 40,
                    child: NumberPicker(personController, "Persons", 1, 8)),
                VerticalSpacer(
                  height: 50,
                ),
                ResponsiveWidget.fullWidth(
                    height: 40,
                    child: NumberPicker(luggageController, "Luggage", 1, 8)),
                VerticalSpacer(
                  height: 50,
                ),
                ResponsiveWidget.fullWidth(
                  height: 60,
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
                 // MainExpansionTileState.of(context).collapse();
                 if (_formKey.currentState.validate()) {
                   if(valueSelected){
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
                   }
                   else
                     CustomToast().showErrorToast("Select a car first !!");


                 }


                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carTile(String carName, Car c) {

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.grey[50],
      shadowColor: Styles.primaryColor(),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.directions_car,
              size: Styles.mediumIconSize(), color: Styles.primaryColor()),
        ),
        title: Row(
          children: [
            Text(
              "Car : " + carName,
              style: Styles.labelTextStyle(),
            ),
          ],
        ),
        onTap: () {
          // CustomToast().showShortToast(
          //     Lang.getString(context, "You_Choosed") + carName,
          //     backgroundColor: Colors.greenAccent);
          selectedCar = carName;
          valueSelected=true;
          car = c;
          setState(() {});
        },
      ),
    );
  }

  Widget getCar() {
    for (int i = 0; i < App.user.driver.cars.length; i++) {
      return carTile(
          App.user.driver.cars[i].brand + " / " + App.user.driver.cars[i].name,
          App.user.driver.cars[i]);
    }
  }
}
