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
  NumberController numberController = NumberController();
  NumberController numberController2 = NumberController();
  int hhhh = 30;
  bool hide = false;
  String selectedCar = "Choose a car";
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: Column(
        children: [
          VerticalSpacer(
            height: 20,
          ),
          ResponsiveWidget(
            width: 270,
            height: hhhh,
            child: MainExpansionTile(
              initiallyExpanded: hide,
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
          VerticalSpacer(
            height: 50,
          ),
          ResponsiveWidget.fullWidth(
              height: 40,
              child: NumberPicker(numberController, "Persons", 1, 8)),
          VerticalSpacer(
            height: 50,
          ),
          ResponsiveWidget.fullWidth(
              height: 40,
              child: NumberPicker(numberController2, "Luggage", 1, 8)),
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
                  Navigator.of(context).pushNamed("/AddRidePage4");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void settt() {
    if (hhhh == 30)
      hhhh = 270;
    else
      hhhh = 30;
    setState(() {});
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
              .showColoredToast("You Choosed  " + name, Colors.greenAccent);
          setState(() {});
          selectedCar = brand + " / " + name;
        },
      ),
    );
  }
}
