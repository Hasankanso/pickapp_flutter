import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/SearchInfo.dart';
import 'package:pickapp/items/SearchResultTile.dart';
import 'package:pickapp/pages/SearchResultFilter.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/ReserveSeat.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/NumberPicker.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SearchResults extends StatefulWidget {
  SearchInfo searchInfo;

  @override
  _SearchResultsState createState() => _SearchResultsState();

  SearchResults({Key key, this.searchInfo}) : super(key: key);
}

class _SearchResultsState extends State<SearchResults> {
  List<Ride> filteredRides;

  bool priceAscending = true;
  bool dateAscending = true;
  FilterController filterController = new FilterController();

  final _codeFormKey = GlobalKey<FormState>();

  TextEditingController seatsController;
  TextEditingController luggageController;

  Container _buildDivider() {
    return Container(
      width: ScreenUtil().setWidth(340),
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  void filter(List<Ride> newList) {
    setState(() {
      filteredRides = newList;
    });
  }

  sortBestMatch() {
    setState(() {
      widget.searchInfo.rides.sort((r1, r2) {
        Duration distance1 =
            r1.leavingDate.difference(widget.searchInfo.minDate).abs();
        Duration distance2 =
            r2.leavingDate.difference(widget.searchInfo.minDate).abs();
        return distance1 > distance2 ? -1 : 1;
      });
      dateAscending = true;
      priceAscending = true;
    });
  }

  sortPrice() {
    setState(() {
      if (priceAscending) {
        widget.searchInfo.rides.sort((r1, r2) => r1.price > r2.price ? 1 : -1);
      } else {
        widget.searchInfo.rides.sort((r1, r2) => r1.price > r2.price ? -1 : 1);
      }
      priceAscending = !priceAscending;
      dateAscending = true;
    });
  }

  sortDate() {
    setState(() {
      if (dateAscending) {
        widget.searchInfo.rides
            .sort((r1, r2) => r1.leavingDate.isAfter(r2.leavingDate) ? 1 : -1);
      } else {
        widget.searchInfo.rides
            .sort((r1, r2) => r1.leavingDate.isBefore(r2.leavingDate) ? 1 : -1);
      }
      dateAscending = !dateAscending;
      priceAscending = true;
    });
  }

  @override
  void initState() {
    filterController.priceController.values =
        new RangeValues(0, App.maxPriceFilter);
    filterController.priceController.maxAbsolute = App.maxPriceFilter;
    filterController.timeController.values = new RangeValues(0, 1440);

    seatsController = TextEditingController(
        text: widget.searchInfo.passengersNumber.toString());
    luggageController = TextEditingController(text: "0");
  }

  @override
  Widget build(BuildContext context) {
    List<Ride> rides;

    if (filteredRides != null) {
      rides = filteredRides;
    } else {
      rides = widget.searchInfo.rides;
    }

    CustomToast().showLongToast(
        rides.length.toString() + " " + Lang.getString(context, "RIDES"),
        backgroundColor: Colors.greenAccent);
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Results"),
      ),
      body: Column(
        children: [
          Card(
              shape: RoundedRectangleBorder(),
              child: Column(
                children: [
                  ResponsiveWidget.fullWidth(
                      height: 60,
                      child: _TopCard(searchInfo: widget.searchInfo)),
                  _buildDivider(),
                  ResponsiveWidget.fullWidth(
                    height: 44,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 40,
                          child: IconButton(
                            color: Styles.primaryColor(),
                            icon: Icon(Icons.filter_alt_outlined,
                                size: Styles.mediumIconSize()),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SearchResultsFilter(
                                      rides: widget.searchInfo.rides,
                                      controller: filterController,
                                      onFiltered: filter,
                                    );
                                  });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 40,
                          child: PopupMenuButton<int>(
                              icon: Icon(
                                Icons.sort,
                                color: Styles.primaryColor(),
                                size: Styles.mediumIconSize(),
                              ),
                              onSelected: (int value) {
                                if (value == 0) {
                                  sortBestMatch();
                                } else if (value == 1) {
                                  sortPrice();
                                } else if (value == 2) {
                                  sortDate();
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                    PopupMenuItem(
                                        value: 0,
                                        child: Row(children: [
                                          Icon(
                                            Icons.auto_awesome,
                                            size: Styles.mediumIconSize(),
                                          ),
                                          Text(
                                              "  " +
                                                  Lang.getString(
                                                      context, "Best_Match"),
                                              style: Styles.valueTextStyle()),
                                        ])),
                                    PopupMenuItem(
                                        value: 1,
                                        child: Row(children: [
                                          Transform.rotate(
                                              angle: 90 * pi / 180,
                                              child: Icon(
                                                Icons.sync_alt,
                                                size: Styles.mediumIconSize(),
                                              )),
                                          Text(
                                              "  " +
                                                  Lang.getString(
                                                      context, "Price"),
                                              style: Styles.valueTextStyle()),
                                        ])),
                                    PopupMenuItem(
                                        value: 2,
                                        child: Row(children: [
                                          Transform.rotate(
                                              angle: 90 * pi / 180,
                                              child: Icon(
                                                Icons.sync_alt,
                                                size: Styles.mediumIconSize(),
                                              )),
                                          Text(
                                              "  " +
                                                  Lang.getString(
                                                      context, "Date"),
                                              style: Styles.valueTextStyle()),
                                        ])),
                                  ]),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Expanded(
            child: ListBuilder(
                list: rides,
                itemBuilder: SearchResultTile.itemBuilder(rides, OnPressed)),
          ),
        ],
      ),
    );
  }

  void OnPressed(Ride r) {
    Function callbackFunction;
    String buttonName = "Back";
    if ((App.user.driver != null && r.driver.id == App.user.driver.id) ||
        App.getRideFromObjectId(r.id) != null) {
      callbackFunction = (Ride r) => Navigator.of(context).pop();
    } else {
      callbackFunction = (Ride r) => seatsLuggagePopUp(r, context);
      buttonName = Lang.getString(context, "Reserve");
    }

    Navigator.of(context).pushNamed("/RideDetails",
        arguments: [r, buttonName, callbackFunction]);
  }

  void response(Ride r, int status, String reason, BuildContext context) {
    if (status == 200) {
      App.person.upcomingRides.add(r);
      //Cache.setUserCache(App.user);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Ride_Reserved_Success"));
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pop(context);
      //todo in backendless you should send a specific case for this validation, and after handling all what we want, w put general validation
      CustomToast()
          .showErrorToast(Lang.getString(context, "Ride_Reserved_Failed"));
    }
  }

  void seatsLuggagePopUp(Ride ride, BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black45,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: Styles.labelTextStyle(),
      descStyle: Styles.valueTextStyle(),
      animationDuration: Duration(milliseconds: 400),
    );
    NumberController seatsController = new NumberController();
    NumberController luggageController = new NumberController();
    Alert(
        context: context,
        style: alertStyle,
        title: Lang.getString(context, "Reserve_Seats_Luggage"),
        desc: Lang.getString(context, "Reserve"),
        content: Form(
          key: _codeFormKey,
          child: Column(
            children: [
              NumberPicker(
                seatsController,
                "Seats",
                1,
                ride.availableSeats,
                isSmallIconSize: true,
              ),
              NumberPicker(
                luggageController,
                "Luggage",
                0,
                ride.availableLuggages,
                isSmallIconSize: true,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(Lang.getString(context, "Confirm"),
                style: Styles.buttonTextStyle(),
                overflow: TextOverflow.visible),
            color: Styles.primaryColor(),
            onPressed: () {
              if (_codeFormKey.currentState.validate()) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Center(
                        child: Spinner(),
                      ),
                    );
                  },
                );
                Request<Ride> req = ReserveSeat(
                    ride,
                    App.user,
                    seatsController.chosenNumber,
                    luggageController.chosenNumber);
                req.send((r, status, reason) =>
                    response(ride, status, reason, context));
              }
            },
          ),
        ]).show();
  }
}

class _TopCard extends StatelessWidget {
  SearchInfo searchInfo;

  _TopCard({this.searchInfo});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                searchInfo.from.name,
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(
              Icons.arrow_right_alt,
              size: Styles.mediumIconSize(),
            ),
            Flexible(
              child: Text(
                searchInfo.to.name,
                style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd/MM/yy').add_jm().format(searchInfo.minDate) + ", ",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: ScreenUtil().setSp(12)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              Lang.getString(context, "Seats") +
                  " " +
                  searchInfo.passengersNumber.toString(),
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: ScreenUtil().setSp(12)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        )
      ],
    );
  }
}
