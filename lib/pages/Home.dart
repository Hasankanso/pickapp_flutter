import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/notifications/LocalNotificationManager.dart';
import 'package:just_miles/pages/AddRide.dart';
import 'package:just_miles/pages/Inbox.dart';
import 'package:just_miles/pages/LoginRegister.dart';
import 'package:just_miles/pages/MyRides.dart';
import 'package:just_miles/pages/Profile.dart';
import 'package:just_miles/pages/Search.dart';
import 'package:just_miles/utilities/CustomToast.dart';

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
    super.initState();
    LocalNotificationManager.initializeLocaleNotification(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      App.isAppBuild = true;
    });
  }

  response(String userStatus, int code, String message, context) async {
    if (code != HttpStatus.ok) {
      if (code == -1 || code == -2) {
        await App.logout();
        CustomToast().showErrorToast(Lang.getString(context, message));
      } else if (code == -3) {
        CustomToast().showErrorToast(Lang.getString(context, message));
      } else {
        CustomToast().showErrorToast(message);
      }
    }
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
                BoxShadow(spreadRadius: -4, offset: Offset(0, -4), color: Colors.grey)
              ]),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list_alt), label: Lang.getString(context, "My_Rides")),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.drive_eta),
                    label: Lang.getString(context, "Add_Ride"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: Lang.getString(context, "Search"),
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                        ),
                        ValueListenableBuilder(
                          builder: (BuildContext context, bool isNewMessage, Widget child) {
                            if (_currenIndex == 3) {
                              App.isNewMessageNotifier.value = false;
                              isNewMessage = false;
                            }
                            return Visibility(
                              visible: isNewMessage,
                              child: Positioned(
                                top: 0,
                                left: !App.isLTR ? 0 : null,
                                right: App.isLTR ? 0 : null,
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
                          valueListenable: App.isNewMessageNotifier,
                        ),
                      ],
                    ),
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
