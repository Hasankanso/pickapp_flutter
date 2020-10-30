import 'package:flutter/material.dart';

import 'AddRide.dart';
import 'Chat.dart';
import 'MyRides.dart';
import 'Profile.dart';
import 'Search.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currenIndex = 2;

  PageController pageController = PageController(
    initialPage: 2,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
  }

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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'My Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Add Ride',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.all_inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
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
