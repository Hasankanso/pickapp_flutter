import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';

class Switcher extends StatefulWidget {
  bool isOn = false;
  SwitcherController controller;
  Switcher({this.isOn, this.controller});
  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.controller.isOn = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    if (!App.isIphone()) {
      return CupertinoSwitch(
        value: widget.isOn,
        onChanged: (bool value) {
          setState(() {
            widget.isOn = value;
            widget.controller.isOn = value;
          });
        },
        activeColor: Styles.primaryColor(),
      );
    } else if (App.isAndroid()) {
      return Switch(
        onChanged: (value) {
          setState(() {
            widget.isOn = value;
            widget.controller.isOn = value;
          });
        },
        value: widget.isOn,
        activeColor: Styles.primaryColor(),
        inactiveThumbColor: Styles.labelColor(),
      );
    }
  }
}

class SwitcherController {
  bool isOn;
}
