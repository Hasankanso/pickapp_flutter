import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/pages/AddRide.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/pages/MyRides.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/Search.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/Startup.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currenIndex = 2;
  List<Widget> _pages = [
    MyRides(),
    AddRide(),
    Search(),
    Inbox(),
    Profile(),
  ];
  PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  void _pageSwipped(int index) {
    setState(() {
      _currenIndex = index;
    });
  }

  void _bottomTapped(int index) {
    if ((_currenIndex - index).abs() == 1) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      pageController.jumpToPage(index);
    }
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (App.user != null) {
      //List<String> channels = ["default"];
      List<String> deviceObjectIds = List<String>();
      //await Backendless.messaging.registerDevice(channels).then((response) {
      //var ids = response.toJson()["channelRegistrations"];
      //for (final channel in channels) deviceObjectIds.add(ids["$channel"]);
      //});
      Request<String> request = Startup(App.user, deviceObjectIds);
      request.send((userStatus, code, message) =>
          response(userStatus, code, message, context));
    }
  }

  pushLocalNotification(
      {@required String title,
      @required String message,
      @required Duration duration,
      @required String payload,
      String subtitle}) async {
    String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        message,
        tz.TZDateTime.now(tz.local).add(duration),
        NotificationDetails(
            android: AndroidNotificationDetails(
                'ss', 'sss', 'upcoming ride channel description',
                color: Colors.blue,
                importance: Importance.high,
                priority: Priority.high,
                channelShowBadge: true,
                enableVibration: true,
                autoCancel: true,
                subText: subtitle,
                fullScreenIntent: true),
            iOS: IOSNotificationDetails(
              presentBadge: true,
              presentSound: true,
              subtitle: subtitle,
            )),
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Widget build(BuildContext context) {
    App.setContext(context);
    return ValueListenableBuilder(
      builder: (BuildContext context, bool isLoggedIn, Widget child) {
        if (!isLoggedIn) {
          return LoginRegister();
        }
        return Scaffold(
            backgroundColor: Styles.secondaryColor(),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                pushLocalNotification(
                  title: 'Upcoming ride',
                  message: 'You have a ride after 30 minutes',
                  payload: "UpcomingRide",
                  duration: Duration(seconds: 10),
                );
              },
            ),
            body: PageView(
              controller: pageController,
              onPageChanged: _pageSwipped,
              children: _pages,
            ),
            bottomNavigationBar: AspectRatio(
                aspectRatio: 13 / 2,
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt),
                        label: Lang.getString(context, "My_Rides")),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.drive_eta),
                      label: Lang.getString(context, "Add_Ride"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search),
                      label: Lang.getString(context, "Search"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_outlined),
                      label: Lang.getString(context, "Chats"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.account_circle),
                      label: Lang.getString(context, "Profile"),
                    ),
                  ],
                  currentIndex: _currenIndex,
                  iconSize: ScreenUtil().setSp(23),
                  selectedFontSize: ScreenUtil().setSp(12),
                  selectedItemColor: Styles.primaryColor(),
                  unselectedItemColor: Styles.labelColor(),
                  onTap: _bottomTapped,
                )));
      },
      valueListenable: App.isLoggedInNotifier,
    );
  }

  response(String userStatus, int code, String message, context) async {
    if (code != HttpStatus.ok) {
      if (code == -1 || code == -2) {
        await Hive.openBox("regions");
        var regionB = Hive.box("regions");
        await regionB.clear();
        regionB.close();
        var userB = Hive.box("user");
        userB.clear();
        App.user = null;
        App.isLoggedIn = false;
        App.isDriverNotifier.value = false;
        App.isLoggedInNotifier.value = false;
        CustomToast().showErrorToast(Lang.getString(context, message));
      } else if (code == -3) {
        CustomToast().showErrorToast(Lang.getString(context, message));
      } else {
        CustomToast().showErrorToast(message);
      }
    } else {}
  }
}
