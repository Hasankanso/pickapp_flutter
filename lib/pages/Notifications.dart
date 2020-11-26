import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
        title: Lang.getString(context, "Notifications"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: Styles.secondaryColor(),
              size: Styles.largeIconSize(),
            ),
            //tooltip: Lang.getString(context, "Settings"),
            onPressed: () {
              a();
              //Navigator.of(context).pushNamed("/settings");
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveWidget.fullWidth(
                height: 150,
                child: FromToPicker(
                    fromController: fromController,
                    toController: toController)),
            VerticalSpacer(height: 30),
            ResponsiveWidget.fullWidth(
                height: 80, child: DateTimeRangePicker(dateTimeController)),
            VerticalSpacer(height: 20),
            ResponsiveWidget.fullWidth(
                height: 59,
                child: NumberPicker(numberController,
                    Lang.getString(context, "Persons"), 1, 8)),
            Container(
              height: ScreenUtil().setHeight(120),
              child: TextField(
                minLines: 10,
                maxLines: null,
                decoration: InputDecoration(labelText: "Description"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.red,
        height: 50,
        child: Center(
          child: MainButton(
            text_key: "Search",
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
