import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/SearchInfo.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/SearchForRides.dart';
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

  response(List<Ride> result, int code, String message) {
    print(result);
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
              height: 130,
              child: FromToPicker(
                  fromController: fromController, toController: toController)),
          VerticalSpacer(height: 30),
          ResponsiveWidget.fullWidth(
              height: 80, child: DateTimeRangePicker(dateTimeController)),
          VerticalSpacer(height: 30),
          ResponsiveWidget.fullWidth(
              height: 30,
              child: NumberPicker(numberController, "Persons", 1, 8)),
          VerticalSpacer(height: 170),
          ResponsiveWidget(
            width: 270,
            height: 50,
            child: MainButton(
              text_key: "Search",
              onPressed: () {
                Request.initBackendless();
                MainLocation to = MainLocation(
                    name: toController.description,
                    latitude: toController.location.lat,
                    longitude: toController.location.lng,
                    placeId: toController.placeId);
                MainLocation from = MainLocation(
                    name: fromController.description,
                    latitude: fromController.location.lat,
                    longitude: fromController.location.lng,
                    placeId: fromController.placeId);
                SearchInfo searchInfo = SearchInfo(
                    to: to,
                    from: from,
                    passengersNumber: numberController.chosenNumber,
                    minDate: dateTimeController.startDateController.chosenDate,
                    maxDate: dateTimeController.endDateController.chosenDate);
                Request<List<Ride>> request = SearchForRides(searchInfo);
                request.send(response);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
