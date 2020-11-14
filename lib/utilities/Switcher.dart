import 'package:flutter/material.dart';
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

class SwitcherController {
  bool isOn;
}
