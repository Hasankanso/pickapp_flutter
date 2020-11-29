import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddRidePage4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(height: 20,),
            ResponsiveWidget.fullWidth(
              height: 40,
              child: ResponsiveRow(
                children: [
                  Text(
                    "Choose a route from the maps below :",
                    style: Styles.labelTextStyle(),
                  )
                ],
              ),
            ),
            VerticalSpacer(height: 20,),
            ResponsiveWidget(
              width: 270,
              height: 200,
              child: Image(
                image: AssetImage("lib/images/map.jpg"),
              ),
            ),
            VerticalSpacer(height: 20,),
            ResponsiveWidget(
              width: 270,
              height: 200,
              child: Image(
                image: AssetImage("lib/images/map.jpg"),
              ),
            )

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
                text_key: "DONE",
                onPressed: () {
                  Navigator.of(context).pushNamed("/");
                  CustomToast().showColoredToast("Ride Added ", Colors.greenAccent);
                },
              ),
            ),
          ],
        ),
      ),

    );
  }
}
