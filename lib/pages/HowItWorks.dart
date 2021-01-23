import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class HowItWorks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "How_It_Works"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpacer(height: 20),
              ResponsiveRow(
                widgetRealtiveSize: 18,
                children: [
                  Text(
                    "Car owners who are planning for a car journey, offer their ride" +
                        " online, specifying itinerary, ride permissions, and price. Co-travelers interested in this journey," +
                        " reserve a seat and can contact the driver via a private message system." +
                        " They then travel together and co-travelers pay.",
                    style: Styles.valueTextStyle(),
                  ),
                ],
              ),
              VerticalSpacer(height: 20),
              ResponsiveRow(
                widgetRealtiveSize: 18,
                children: [
                  Text(
                    "Alert",
                    style: Styles.headerTextStyle(),
                  ),
                ],
              ),
              VerticalSpacer(height: 10),
              ResponsiveRow(
                widgetRealtiveSize: 18,
                children: [
                  Text(
                    "We strongly recommend using this feature if the passenger didn't" +
                        " find a ride offer, therefore he will alert all the drivers about" +
                        " his/her ride information then the driver will add a new ride.",
                    style: Styles.valueTextStyle(),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
