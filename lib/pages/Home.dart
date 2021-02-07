import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/pages/AddRide.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:pickapp/pages/LoginRegister.dart';
import 'package:pickapp/pages/MyRides.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/Search.dart';

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
    if ((_currenIndex - index).abs() == 1 && !Cache.disableAnimation) {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      pageController.jumpToPage(index);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //MainNotification.initializeLocaleNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    App.setContext(context);
    if (App.notifications != null &&
        App.notifications.isNotEmpty &&
        App.notifications[App.notifications.length - 1].scheduleDate
                .compareTo(DateTime.now()) >=
            0) {
      App.isNewNotificationNotifier.value = true;
    }
    return ValueListenableBuilder(
      builder: (BuildContext context, bool isLoggedIn, Widget child) {
        if (!isLoggedIn) {
          return LoginRegister();
        }
        return Scaffold(
          backgroundColor: Styles.secondaryColor(),
          body: PageView(
            controller: pageController,
            onPageChanged: _pageSwipped,
            children: _pages,
          ),
          bottomNavigationBar: SafeArea(
              child: AspectRatio(
            aspectRatio: 13 / 2,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    spreadRadius: -4, offset: Offset(0, -4), color: Colors.grey)
              ]),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
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
                elevation: 0,
                onTap: _bottomTapped,
              ),
            ),
          )),
        );
      },
      valueListenable: App.isLoggedInNotifier,
    );
  }
}
