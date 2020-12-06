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
          _TopCard(searchInfo: widget.searchInfo),
          ResponsiveWidget.fullWidth(
            height: 30,
            child: Row(
              children: [
                Spacer(),
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
                  flex: 80,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20.0,
                              spreadRadius: 0.5,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.only(left: 44.0),
                        margin:
                            EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0),
                        child: DropdownButton(
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
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 7, left: 100),
                        child: Icon(
                          Icons.sort,
                          color: Styles.primaryColor(),
                          size: Styles.mediumIconSize(),
                        ),
                      ),
                    ],
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

class _TopCard extends StatelessWidget {
  SearchInfo searchInfo;

  _TopCard({this.searchInfo});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 50,
      child: Card(
        shape: RoundedRectangleBorder(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                Expanded(
                  flex: 40,
                  child: Text(
                    searchInfo.from.name,
                    style: TextStyle(fontSize: ScreenUtil().setSp(10)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Icon(
                  Icons.arrow_right_alt,
                  size: Styles.mediumIconSize(),
                ),
                Expanded(
                  flex: 40,
                  child: Text(
                    searchInfo.to.name,
                    style: TextStyle(fontSize: ScreenUtil().setSp(10)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Spacer(),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                Expanded(
                  flex: 81,
                  child: Text(
                    DateFormat('dd/MM/yy').format(searchInfo.minDate) +
                        ", " +
                        searchInfo.passengersNumber.toString() +
                        " " +
                        Lang.getString(context, "Seats"),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.caption.color,
                        fontSize: ScreenUtil().setSp(8)),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
