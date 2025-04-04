import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/items/MyRidesHistoryTile.dart';
import 'package:just_miles/items/MyRidesTile.dart';
import 'package:just_miles/requests/GetMyUpcomingRides.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';

class MyRides extends StatefulWidget {
  @override
  _MyRidesState createState() => _MyRidesState();
}

class _MyRidesState extends State<MyRides> {
  List<Ride> ridesHistory = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    await getRidesHistory();
  }

  Future<void> checkOutDatedRides() async {
    bool needUpdate = false;
    List<Ride> toRemove = <Ride>[];

    if (App.person.upcomingRides != null) {
      for (final ride in App.person.upcomingRides) {
        DateTime d = ride.leavingDate.add(
            Duration(hours: App.person.countryInformations.rateStartHours));
        if (DateTime.now().isAfter(d)) {
          needUpdate = true;
          ridesHistory.add(ride);
          toRemove.add(ride);
        }
      }
      if (needUpdate) {
        App.person.upcomingRides.removeWhere((e) => toRemove.contains(e));
        await Cache.updateRideHistory(ridesHistory);
        await Cache.setUser(App.user);
      }
    }
  }

  Future<void> getRidesHistory() async {
    ridesHistory = await Cache.getRidesHistory();
    await checkOutDatedRides();
    App.updateUpcomingRide.value = !App.updateUpcomingRide.value;
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
                  child: Text(Lang.getString(context, "Upcoming"),
                      style: Styles.valueTextStyle()),
                ),
                Tab(
                  child: Text(Lang.getString(context, "History"),
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
                    App.person.upcomingRides
                        .sort((a, b) => a.leavingDate.compareTo(b.leavingDate));
                    return Container(
                      child: ListBuilder(
                        list: App.person.upcomingRides,
                        itemBuilder:
                            MyRidesTile.itemBuilder(App.person.upcomingRides),
                        nativeAdHeight: ScreenUtil().setSp(120),
                        onPullRefresh: () async {
                          await _getUpcomingRides();
                        },
                      ),
                    );
                  }),
              ValueListenableBuilder(
                  valueListenable: App.updateUpcomingRide,
                  builder: (BuildContext context, bool isd, Widget child) {
                    ridesHistory
                        .sort((a, b) => b.leavingDate.compareTo(a.leavingDate));
                    return Container(
                      child: ridesHistory.length > 0
                          ? ListBuilder(
                              list: ridesHistory,
                              itemBuilder:
                                  MyRidesHistoryTile.itemBuilder(ridesHistory),
                              nativeAdHeight: ScreenUtil().setSp(125),
                            )
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

  getRidesCallBack(List<Ride> rides, int code, String message) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }
    if (code != 200) {
    } else if (rides != null) {
      List<Ride> historyRides = [];
      List<Ride> updatedUpcomingRides = List.from(rides);
      for (int i = 0; i < rides.length; i++) {
        DateTime d = rides[i].leavingDate.add(
            Duration(hours: App.person.countryInformations.rateStartHours));
        if (DateTime.now().isAfter(d) || rides[i].status == "CANCELED") {
          historyRides.add(rides[i]);
          updatedUpcomingRides.remove(rides[i]);
        }
      }
      App.person.upcomingRides = updatedUpcomingRides;
      await App.updateUserCache();
      ridesHistory = historyRides;
      await Cache.updateRideHistory(historyRides);
    }
  }

  Future<void> _getUpcomingRides() async {
    Request<List<Ride>> getRides = GetMyUpComingRides();
    await getRides.send(getRidesCallBack);
  }
}
