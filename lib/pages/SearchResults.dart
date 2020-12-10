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
import 'package:pickapp/utilities/CustomToast.dart';
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
    });
  }

  sortPrice(bool ascending) {
    setState(() {
      if (ascending) {
        widget.searchInfo.rides.sort((r1, r2) => r1.price > r2.price ? 1 : -1);
      } else {
        widget.searchInfo.rides.sort((r1, r2) => r1.price > r2.price ? -1 : 1);
      }
    });
  }

  sortDate(bool ascending) {
    setState(() {
      if (ascending) {
        widget.searchInfo.rides
            .sort((r1, r2) => r1.leavingDate.isAfter(r2.leavingDate) ? 1 : -1);
      } else {
        widget.searchInfo.rides
            .sort((r1, r2) => r1.leavingDate.isBefore(r2.leavingDate) ? 1 : -1);
      }
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
    CustomToast().showLongToast(
        rides.length.toString() + Lang.getString(context, "RIDES"),
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
                      height: 40,
                      child: _TopCard(searchInfo: widget.searchInfo)),
                  _buildDivider(),
                  ResponsiveWidget.fullWidth(
                    height: 35,
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
                                  sortPrice(true);
                                } else if (value == 2) {
                                  sortPrice(false);
                                } else if (value == 3) {
                                  sortDate(true);
                                } else if (value == 4) {
                                  sortDate(false);
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<int>>[
                                    PopupMenuItem(
                                        value: 0,
                                        child: Row(children: [
                                          Icon(Icons.auto_awesome),
                                          Text("Best_Match"),
                                        ])),
                                    PopupMenuItem(
                                        value: 1,
                                        child: Row(children: [
                                          Icon(Icons.upload_rounded),
                                          Text("Price"),
                                        ])),
                                    PopupMenuItem(
                                        value: 2,
                                        child: Row(children: [
                                          Icon(Icons.download_rounded),
                                          Text("Price"),
                                        ])),
                                    PopupMenuItem(
                                        value: 3,
                                        child: Row(children: [
                                          Icon(Icons.upload_rounded),
                                          Text("Date"),
                                        ])),
                                    PopupMenuItem(
                                        value: 4,
                                        child: Row(children: [
                                          Icon(Icons.download_rounded),
                                          Text("Date"),
                                        ]))
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
                itemBuilder: RideResultListTile.itemBuilder(rides)),
          ),
        ],
      ),
    );
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
            Text(
              searchInfo.from.name,
              style: TextStyle(fontSize: ScreenUtil().setSp(10)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Icon(
              Icons.arrow_right_alt,
              size: Styles.mediumIconSize(),
            ),
            Text(
              searchInfo.to.name,
              style: TextStyle(fontSize: ScreenUtil().setSp(10)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('dd/MM/yy').add_jm().format(searchInfo.minDate) +
                  ", " +
                  searchInfo.passengersNumber.toString() +
                  " " +
                  Lang.getString(context, "Seats") +
                  "   ",
              style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: ScreenUtil().setSp(8)),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        )
      ],
    );
  }
}
