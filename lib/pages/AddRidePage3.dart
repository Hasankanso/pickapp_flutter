import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
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
  final Ride rideInfo;
  NumberController personController = NumberController();
  NumberController luggageController = NumberController();
  final priceController = TextEditingController();
  String selectedCar;

  _AddRidePage3State(this.rideInfo);

  @override
  Widget build(BuildContext context) {
    selectedCar = Lang.getString(context, "Choose_A_Car");
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: SingleChildScrollView(
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
                  style: Styles.labelTextStyle(),
                ),
                children: <Widget>[
                  carTile(App.user.driver.cars[0].name.toString(),App.user.driver.cars[0].name.toString()),
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
              height: 30,
              child: Row(
                children: [
                  Spacer(),
                  Expanded(
                      flex: 4,
                      child: Text(
                        Lang.getString(context, "Price"),
                        style: Styles.labelTextStyle(),
                      )),
                  Expanded(
                      flex: 1,
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: Lang.getString(context, "LBP")),
                      )),
                  Spacer(),
                ],
              ),
            ),
          ],
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

                  int seats = personController.chosenNumber;
                  int luggage = luggageController.chosenNumber;
                  rideInfo.availableSeats = seats;
                  rideInfo.availableLuggages = luggage;
                  rideInfo.car=App.user.driver.cars[0];
                  //rideInfo.car=null;
                  if(priceController.text!=""){
                    int price = int.parse(priceController.text);
                    rideInfo.price = price ;
                    Navigator.of(context)
                        .pushNamed("/AddRidePage4", arguments: rideInfo);
                  }
                  else CustomToast().showErrorToast("Enter Price first");


                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget carTile(String brand, String name) {
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
              "Car : ",
              style: Styles.labelTextStyle(),
            ),
            Text(
              brand + "  /",
              style: Styles.valueTextStyle(),
            ),
            Text(
              name,
              style: Styles.valueTextStyle(),
            )
          ],
        ),
        onTap: () {
          CustomToast().showShortToast(
              Lang.getString(context, "You_Choosed") + name,
              backgroundColor : Colors.greenAccent);
          setState(() {});
          selectedCar = brand + " / " + name;
          MainExpansionTileState.of(context).collapse();
        },
      ),
    );
  }
}
