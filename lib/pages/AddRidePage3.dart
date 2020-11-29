import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
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
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: Column(
        children: [
          VerticalSpacer(height: 20,),
          ResponsiveWidget.fullWidth(
            height: 20,
            child: Row(
              children: [
                Expanded(flex: 12,child: SizedBox()),
                Expanded(
                    flex: 53, child: Text("Press the arrow to choose a car ",style: Styles.labelTextStyle(),)),
                Expanded(flex:23
                    ,child:IconButton(
                      icon:Icon(Icons.arrow_downward,color: Styles.primaryColor(),),
                      onPressed: (){
                        CustomToast().showColoredToast("List Of Cars Should be Opened", Colors.pink);
                      },
                    )
                ),
              ],
            ),
          ),
          VerticalSpacer(height: 50,),
          ResponsiveWidget.fullWidth(
              height: 40,
              child: NumberPicker(
                  numberController,
                  "Persons",
                  1, 8)
          ),
          VerticalSpacer(height: 50,),
          ResponsiveWidget.fullWidth(
              height: 40,
              child: NumberPicker(
                  numberController2,
                  "Luggage",
                  1, 8)
          ),
          VerticalSpacer(height: 50,),
          ResponsiveWidget.fullWidth(
            height: 30,
            child: Row(
              children: [
                Expanded(flex: 1,child: SizedBox()),
                Expanded(
                    flex: 4, child: Text(Lang.getString(context, "Price"),style: Styles.labelTextStyle(),)),
                Expanded(
                    flex:1
                    ,child:TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "     LL"
                  ),
                    )
                ),
                Expanded(flex: 1,child: SizedBox()),
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
