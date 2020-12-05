import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:pickapp/Items/RideResultListTile.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/SearchInfo.dart';
import 'package:pickapp/pages/SearchResultFilter.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class SearchResults extends StatefulWidget {
  SearchInfo searchInfo;

  @override
  _SearchResultsState createState() => _SearchResultsState();

  SearchResults({Key key, this.searchInfo}) : super(key: key);
}

class _SearchResultsState extends State<SearchResults> {
  List<Ride> filteredRides;

  Container _buildDivider() {
    return Container(
      width: ScreenUtil().setWidth(340),
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }

  void sort(int index) {
    print(index);
  }

  void filter(List<Ride> newList) {
    setState(() {
      filteredRides = newList;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Ride> rides;
    if (filteredRides != null) {
      rides = filteredRides;
    } else {
      rides = widget.searchInfo.rides;
    }

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
                                              .format(
                                                  widget.searchInfo.minDate),
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
                  ),
                ),
                _buildDivider(),
                ResponsiveWidget.fullWidth(
                  height: 40,
                  child: DefaultTabController(
                    length: 2,
                    child: TabBar(
                      unselectedLabelColor:
                          Theme.of(context).textTheme.bodyText1.color,
                      indicatorColor: Colors.transparent,
                      tabs: [
                        IconButton(
                          color: Styles.primaryColor(),
                          icon: Icon(Icons.filter_alt_outlined),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SearchResultsFilter(
                                    rides: widget.searchInfo.rides,
                                    onFiltered: filter,
                                  );
                                });
                          },
                        ),
                        DropdownButton(
                          icon: Icon(
                            Icons.sort,
                            color: Styles.primaryColor(),
                          ),
                          underline: Container(color: Colors.transparent),
                          isExpanded: true,
                          items: [
                            DropdownMenuItem(
                                value: 0,
                                child: Row(children: [
                                  Icon(Icons.upload_rounded),
                                  Text("Price"),
                                ])),
                            DropdownMenuItem(
                                value: 1,
                                child: Row(children: [
                                  Icon(Icons.download_rounded),
                                  Text("Price"),
                                ]))
                          ],
                          onChanged: sort,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListBuilder(
                list: rides,
                itemBuilder: RideResultListTile.itemBuilder(rides)),
          ),
        ],
      ),
      floatingWidget: ResponsiveWidget(
        height: 20,
        width: 80,
        child: FloatingActionButton.extended(
          splashColor: Colors.transparent,
          onPressed: () {
            // Add your onPressed code here!
          },
          label: Text(rides.length.toString() + " RIDES",
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                color: Styles.secondaryColor(),
              )),
          backgroundColor: Styles.primaryColor(),
        ),
      ),
      floatingLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  sortPrice(bool ascending) {}
}
