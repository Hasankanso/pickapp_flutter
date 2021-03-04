import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:pickapp/classes/Ads.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/MainLocation.dart';
import 'package:pickapp/dataObjects/Person.dart';
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
import 'package:pickapp/utilities/MainNativeAd.dart';
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
  final _controller = NativeAdmobController();

// Optional: Set the option to disable the personalized Ads. AdMob default option: personalized
  // _controller.setNonPersonalizedAds(true);

  SearchInfo _searchInfo;
  String _fromError, _toError;

  response(List<Ride> result, int code, String message) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      _searchInfo.rides = result;
      Navigator.of(context).pushNamed("/RideResults", arguments: _searchInfo);
    }
  }

  void _sendAnalyticsEvent() async {
    await App.analytics.logEvent(
      name: 'search_event',
      parameters: <String, dynamic>{
        'from': 'doueir',
        'to': 'tripoli',
        'time': '12345678910',
      },
    );
  }

  void _testSetUserId() async {
    await App.analytics.setUserId('person_id_or_user_id');
  }

  Future<void> _testSetCurrentScreen() async {
    await App.analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
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
                  //Navigator.of(context).pushNamed("/Notifications");
                  Navigator.of(context).pushNamed("/AddRate", arguments: [
                    Ride(id: "4F3958A5-FAFE-47D0-B17C-F984E7D902EC"),
                    Person(id: "0776BCB3-BD95-4CE8-8CD0-827CBB8C4188")
                  ]);
                },
              ),
              ValueListenableBuilder(
                builder: (BuildContext context, bool isNewNotification,
                    Widget child) {
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
                height: 35,
                child: NumberPicker(numberController, "Persons", 1, 8)),
            VerticalSpacer(height: 30),
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
                _sendAnalyticsEvent();
                _testSetUserId();
                String _validateFrom =
                    fromController.validate(context, x: toController);
                String _validateTo =
                    toController.validate(context, x: fromController);
                _fromError = _validateFrom;
                _toError = _validateTo;
                setState(() {});
                if (_validateFrom == null && _validateTo == null) {
                  if (dateTimeController.startDateController.chosenDate
                      .isBefore(DateTime.now())) {
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
                      minDate:
                          dateTimeController.startDateController.chosenDate,
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
