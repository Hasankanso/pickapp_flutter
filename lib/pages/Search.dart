import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/SearchInfo.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/SearchForRides.dart';
import 'package:pickapp/utilities/Buttons.dart';
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
  SearchInfo _searchInfo;

  response(List<Ride> result, int code, String message) {
    List<Ride> rides = new List<Ride>();

    rides.add(Ride(
      from: MainLocation(
        name: "highest price",
      ),
      to: MainLocation(
        name: "price",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 90000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      maxSeats: 2,
      price: 2000,
      leavingDate: new DateTime(2020, 10, 10),
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Late",
      ),
      to: MainLocation(
        name: "Late",
      ),
      maxSeats: 2,
      leavingDate: new DateTime(2015, 10, 10),
      price: 1000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Mid",
      ),
      to: MainLocation(
        name: "Mid",
      ),
      maxSeats: 2,
      leavingDate: new DateTime(2010, 10, 10),
      price: 40000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Early",
      ),
      to: MainLocation(
        name: "Earlyy",
      ),
      maxSeats: 2,
      leavingDate: new DateTime(2005, 10, 10),
      price: 25000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));
    rides.add(Ride(
      from: MainLocation(
        name: "Beirut, Hamra main street",
      ),
      to: MainLocation(
        name: "Nabatieh Al Tahta",
      ),
      leavingDate: new DateTime(2020, 10, 10),
      maxSeats: 2,
      price: 2000,
      maxLuggages: 2,
      availableSeats: 2,
      availableLuggages: 2,
      user: App.user,
    ));

    print(result);
    _searchInfo.rides = rides;
    Navigator.of(context).pushNamed("/RideResults", arguments: _searchInfo);
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
              Navigator.of(context).pushNamed("/Notifications");
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveWidget.fullWidth(
                height: 130,
                child: FromToPicker(
                    fromController: fromController,
                    toController: toController)),
            VerticalSpacer(height: 30),
            ValueListenableBuilder(
                builder: (BuildContext context, bool rangeBool, Widget child) {
                  return ResponsiveWidget.fullWidth(
                      height: Cache.dateTimeRangePicker ? 140 : 60,
                      child: DateTimeRangePicker(dateTimeController));
                },
              valueListenable: Cache.rangeDateTimeNotifier,
            ),

            VerticalSpacer(height: 30),
            ResponsiveWidget.fullWidth(
                height: 30,
                child: NumberPicker(numberController, "Persons", 1, 8)),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(children: [
          ResponsiveWidget(
            width: 270,
            height: 50,
            child: MainButton(
              text_key: "Search",
              onPressed: () {
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
                _searchInfo = SearchInfo(
                    to: to,
                    from: from,
                    passengersNumber: numberController.chosenNumber,
                    minDate: dateTimeController.startDateController.chosenDate,
                    maxDate: dateTimeController.endDateController.chosenDate);
                Request<List<Ride>> request = SearchForRides(_searchInfo);
                request.send(response);
              },
            ),
          ),
        ]),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
