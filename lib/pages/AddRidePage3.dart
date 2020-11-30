import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainExpansionTile.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddRidePage3 extends StatefulWidget {
  @override
  _AddRidePage3State createState() => _AddRidePage3State();
}

class _AddRidePage3State extends State<AddRidePage3> {
  NumberController personController = NumberController();
  NumberController luggageController = NumberController();
  final priceController = TextEditingController();
  String selectedCar;

  @override
  Widget build(BuildContext context) {
    selectedCar = Lang.getString(context, "Choose_A_Car");
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: Column(
        children: [
          VerticalSpacer(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  alignment: Alignment.centerLeft,
                  constraints: BoxConstraints(minHeight: 70),
                  child: MainExpansionTile(
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
                      carTile("Honda", "Civic"),
                      carTile("Jeep", "Laredo"),
                      carTile("BMW", "E90"),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
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
                Expanded(flex: 1, child: SizedBox()),
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
                Expanded(flex: 1, child: SizedBox()),
              ],
            ),
          ),
        ],
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
                  //Car c = the choosen car id ;
                  int person = personController.chosenNumber;
                  int luggage = luggageController.chosenNumber;
                  int price = int.parse(priceController.text);
                  Navigator.of(context).pushNamed("/AddRidePage4");
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
          CustomToast()
              .showColoredToast(Lang.getString(context, "You_Choosed")+ name, Colors.greenAccent);
          setState(() {});
          selectedCar = brand + " / " + name;
        },
      ),
    );
  }
}
