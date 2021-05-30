import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/items/MyRidesHistoryTile.dart';
import 'package:pickapp/items/MyRidesTile.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  List<Ride> ridesList = [];
  List<Ride> ridesHistory=[];
  @override
  void initState() {
    super.initState();
    checkOutDatedRides();
    if (App.user != null) {
      for (final ride in App.person.upcomingRides) {
        if (ride.status != "CANCELED") ridesList.add(ride);
      }
    }
  }
  Future<void> checkOutDatedRides() async {
    bool needUpdate=false;
    for (final ride in App.person.upcomingRides) {
      DateTime d=ride.leavingDate.add(Duration(hours: App.person.countryInformations.rateStartHours));
      if(DateTime.now().isAfter(d)){
        needUpdate=true;
        ridesHistory.add(ride);
        App.person.upcomingRides.remove(ride);
      }
    }
    if(needUpdate){
      await Cache.updateRideHistory(ridesHistory);
    }
  }
  Future<void> getRidesHistory() async {
    ridesHistory= await Cache.getRidesHistory();
    await Cache.setUser(App.user);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: MainAppBar(
            title: Lang.getString(context, "My_Rides"),
            bottom: TabBar(
              tabs: [
                  Tab(
                   child: Text(
                       Lang.getString(context, "My_Rides"),
                       style: Styles.valueTextStyle()),
                  ),
                Tab(
                  child: Text(
                      Lang.getString(context, "My_Rides_History"),
                      style: Styles.valueTextStyle()),
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              ValueListenableBuilder(
                  valueListenable: App.updateUpcomingRide,
                  builder: (BuildContext context, bool isd, Widget child) {
                    ridesList
                        .sort((a, b) => a.leavingDate.compareTo(b.leavingDate));
                    return Container(
                      child: App.user.person.upcomingRides.length > 0
                          ? ListBuilder(
                              list: ridesList,
                              itemBuilder: MyRidesTile.itemBuilder(ridesList))
                          : Center(
                              child: Text(
                                  Lang.getString(context, "No_upcoming_rides!"),
                                  style: Styles.valueTextStyle())
                      ),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: App.updateUpcomingRide,
                  builder: (BuildContext context, bool isd, Widget child) {
                    ridesHistory
                        .sort((a, b) => a.leavingDate.compareTo(b.leavingDate));
                    return Container(
                      child: ridesHistory.length > 0
                          ? ListBuilder(
                          list: ridesHistory,
                          itemBuilder: MyRidesHistoryTile.itemBuilder(ridesHistory))
                          : Center(
                          child: Text(
                              Lang.getString(context, "No_Rides_History!"),
                              style: Styles.valueTextStyle())),
                    );
                  }),
            ],
          )),
    );
  }
}
