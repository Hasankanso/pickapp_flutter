import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Switcher.dart';

import 'MainAppBar.dart';

class SizeTest extends StatefulWidget {
  Widget body;
  double width, height;

  SizeTest({this.body, this.width, this.height});

  @override
  _TestScaffoldState createState() => _TestScaffoldState();
}

class _TestScaffoldState extends State<SizeTest> {
  double screenWidth = 360, screenHeight = 640;
  double step;
  SwitcherController lockController = new SwitcherController();
  Future<bool> _onPopUp() async {
    App.changeScreenReferenceSize(360, 640);
    return true;
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: MainAppBar(title: "Size Test", actions: [
        Switcher(isOn: lockController.isOn,
          controller: lockController,
        )
      ]),
      body: WillPopScope(
        onWillPop: _onPopUp,
        child: GestureDetector(
          child: Column(
            children: [
              ResponsiveWidget(
                  width: widget.width, height: widget.height, child: widget.body),
            ],
          ),
          onPanUpdate: (details) {
            setState(() {
              if (lockController.isOn) {
                step = details.delta.dx.abs() > details.delta.dy.abs()? details.delta.dx : details.delta.dx;
                screenWidth -= step;
                screenHeight -= step;
              } else {
                screenWidth -= details.delta.dx;
                screenHeight -= details.delta.dy;
              }
              App.changeScreenReferenceSize(screenWidth, screenHeight);
            });
          },
        ),
      ),
    );
  }
}
