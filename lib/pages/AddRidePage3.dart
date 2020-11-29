import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/Buttons.dart';
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
  int hhhh = 70;
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
              leading: Icon(
                Icons.local_taxi_outlined,
                size: Styles.mediumIconSize(),
                color: Colors.grey,
              ),
              title: Text(
                "Choose a car",
                style: Styles.labelTextStyle(),
              ),
              children: <Widget>[
                carTile("BMW", "E90", "lib/images/adel.png", 4, 5),
                carTile("BMW", "E90", "lib/images/adel.png", 4, 5),
                carTile("BMW", "E90", "lib/images/adel.png", 4, 5),
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
                      decoration: InputDecoration(hintText: "     LL"),
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
    if (hhhh == 70)
      hhhh = 270;
    else
      hhhh = 70;
    setState(() {});
  }

  Widget carTile(
      String brand, String name, String imgPath, int seats, int luggage) {
    return Card(
      elevation: 1.0,
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          radius: ScreenUtil().setSp(30),
          backgroundImage: AssetImage(imgPath),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              brand,
              style: Styles.headerTextStyle(),
            ),
          ],
        ),
        subtitle: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: Styles.headerTextStyle(),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              "Seats: ",
                              style: Styles.labelTextStyle(),
                            ),
                            Text(
                              seats.toString(),
                              style:
                                  Styles.valueTextStyle(bold: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text(
                              "Luggage: ",
                              style: Styles.labelTextStyle(),
                            ),
                            Text(
                              luggage.toString(),
                              style:
                                  Styles.valueTextStyle(bold: FontWeight.w500),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
