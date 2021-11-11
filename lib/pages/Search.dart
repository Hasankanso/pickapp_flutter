import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/dataObjects/MainLocation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/dataObjects/SearchInfo.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/requests/SearchForRides.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/DateTimeRangePicker.dart';
import 'package:just_miles/utilities/FromToPicker.dart';
import 'package:just_miles/utilities/LocationFinder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/NumberPicker.dart';
import 'package:just_miles/utilities/Responsive.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search> {
  LocationEditingController fromController = LocationEditingController();
  LocationEditingController toController = LocationEditingController();
  DateTimeRangeController dateTimeController = DateTimeRangeController();
  NumberController numberController = NumberController();

  SearchInfo _searchInfo;
  String _fromError, _toError;

  response(List<Ride> result, int code, String message) {
    if (App.handleErrors(context, code, message)) return;

    _searchInfo.rides = result;
    Navigator.of(context).pushNamed("/RideResults", arguments: _searchInfo);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Search_for_Ride"),
        actions: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
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
              ),
              ValueListenableBuilder(
                builder: (BuildContext context, bool isNewNotification, Widget child) {
                  return Visibility(
                    visible: isNewNotification,
                    child: Positioned(
                      top: 14,
                      left: !App.isLTR ? 11 : null,
                      right: App.isLTR ? 11 : null,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
                valueListenable: App.isNewNotificationNotifier,
              ),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveWidget.fullWidth(
                height: 170,
                child: FromToPicker(
                  fromController: fromController,
                  toController: toController,
                  fromError: _fromError,
                  toError: _toError,
                )),
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
                height: 35, child: NumberPicker(numberController, "Persons", 1, 8)),
            VerticalSpacer(height: 30),
            ResponsiveWidget.fullWidth(
              height: 120,
              child: DifferentSizeResponsiveRow(
                children: [
                  Spacer(
                    flex: 8,
                  ),
                  Expanded(
                    flex: 60,
                    child: MainNativeAd(),
                  ),
                  Spacer(
                    flex: 8,
                  ),
                ],
              ),
            ),
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
              isRequest: true,
              onPressed: () async {
                String _validateFrom = fromController.validate(context, x: toController);
                String _validateTo = toController.validate(context, x: fromController);
                _fromError = _validateFrom;
                _toError = _validateTo;
                setState(() {});
                if (_validateFrom == null && _validateTo == null) {
                  if (dateTimeController.startDateController.chosenDate.isBefore(DateTime.now())) {
                    setState(() {
                      dateTimeController.startDateController.chosenDate =
                          DateTime.now().add(Duration(minutes: 30));
                    });
                  }
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
                  await request.send(response);
                }
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
