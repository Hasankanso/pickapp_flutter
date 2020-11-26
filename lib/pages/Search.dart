import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/DateTimeRangePicker.dart';
import 'package:pickapp/utilities/FromToPicker.dart';
import 'package:pickapp/utilities/LocationFinder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search>
    with AutomaticKeepAliveClientMixin<Search> {
  LocationEditingController fromController = LocationEditingController();
  LocationEditingController toController = LocationEditingController();
  DateTimeRangeController dateTimeController = DateTimeRangeController();
  NumberController numberController = NumberController();
  void a() {
    CustomToast().showColoredToast(" Fuck Notifications !", Colors.amber);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Search_for_Ride"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Styles.secondaryColor(),
              size: Styles.largeIconSize(),
            ),
            tooltip: Lang.getString(context, "Notifications"),
            onPressed: () {
              Navigator.of(context).pushNamed("/notifications");
            },
          )
        ],
      ),
      body: Column(
        children: [
          ResponsiveWidget.fullWidth(
              height: 150,
              child: FromToPicker(
                  fromController: fromController, toController: toController)
          ),
          VerticalSpacer(height: 30),
          ResponsiveWidget.fullWidth(
              height: 80, child: DateTimeRangePicker(dateTimeController)),
          VerticalSpacer(height: 30),
          ResponsiveWidget.fullWidth(
              height: 59,
              child: NumberPicker(
                  numberController, Lang.getString(context, "Persons"), 1, 8)),
          VerticalSpacer(height: 100),
          MainButton(
            text_key: "Search",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
