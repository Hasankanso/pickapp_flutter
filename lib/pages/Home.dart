import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';

import 'package:pickapp/pages/AddRide.dart';
import 'package:pickapp/pages/Chat.dart';
import 'package:pickapp/pages/MyRides.dart';
import 'package:pickapp/pages/Profile.dart';
import 'package:pickapp/pages/Search.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currenIndex = 2;

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
    setState(() {
      _currenIndex = index;
      pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _deviceSize = MediaQuery.of(context);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: _pageSwipped,
        children: <Widget>[
          MyRides(),
          AddRide(),
          Search(),
          Chat(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: Lang.getString(context, "my_rides")),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label:  Lang.getString(context, "add_ride"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: Lang.getString(context, "search"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label:  Lang.getString(context, "chat"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label:  Lang.getString(context, "profile"),
          ),
        ],
        currentIndex: _currenIndex,
        selectedItemColor: Colors.blue,
        iconSize: _deviceSize.size.height * 0.046,
        selectedFontSize: _deviceSize.size.height * 0.023,
        unselectedItemColor: Colors.grey,
        onTap: _bottomTapped,
      ),
    );
  }
}
