import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pickapp/Items/RideResultListTile.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/SearchInfo.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:intl/intl.dart';

class SearchResults extends StatefulWidget {
  SearchInfo searchInfo;

  @override
  _SearchResultsState createState() => _SearchResultsState();

  SearchResults({Key key, this.searchInfo}) : super(key: key);
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    List<Ride> rides = widget.searchInfo.rides;

    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Results"),
        ),
        body: Column(
          children: [
            ResponsiveWidget.fullWidth(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.panorama_fish_eye,
                                color: Styles.primaryColor(),
                                size: Styles.smallIconSize()),
                            Icon(Icons.more_vert,
                                color: Styles.primaryColor(),
                                size: Styles.smallIconSize()),
                            Icon(Icons.circle,
                                color: Styles.primaryColor(),
                                size: Styles.smallIconSize()),
                          ]),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    " " + widget.searchInfo.from.name,
                                    style: Styles.valueTextStyle(),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  child: Text(
                                    " " + widget.searchInfo.to.name,
                                    style: Styles.valueTextStyle(),
                                    overflow: TextOverflow.fade,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                    Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.date_range,
                                    color: Styles.primaryColor(),
                                    size: Styles.smallIconSize()),
                                Text(
                                    " " +
                                        DateFormat('dd/MM/yy')
                                            .add_jm()
                                            .format(widget.searchInfo.minDate),
                                    style: Styles.valueTextStyle()),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(Icons.event_seat,
                                      color: Styles.primaryColor(),
                                      size: Styles.smallIconSize()),
                                ),
                                Spacer(flex: 5),
                                Expanded(
                                  flex: 21,
                                  child: Text(
                                      widget.searchInfo.passengersNumber
                                          .toString(),
                                      style: Styles.valueTextStyle()),
                                ),
                              ],
                            ),
                          ],
                        ))
                  ],
                )),
            Expanded(
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: rides.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 100.0,
                        child: FadeInAnimation(
                          child: RideResultListTile(rides[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ResponsiveWidget(
          height: 60,
          width: 150,
          child: Column(children: [
            MainButton(text_key: "Filter"),
            VerticalSpacer(height: 9)
          ]),
        ));
  }
}
