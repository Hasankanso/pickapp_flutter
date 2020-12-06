import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';

class Switcher extends StatefulWidget {
  bool isOn = false;
  SwitcherController controller;
  void Function(bool) onChanged;

  Switcher({this.isOn, this.controller, this.onChanged});

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.controller !=null) {
      widget.controller.isOn = widget.isOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (App.isIphone()) {
      return CupertinoSwitch(
        value: widget.isOn,
        onChanged: _onChanged,
        activeColor: Styles.primaryColor(),
      );
    } else if (App.isAndroid()) {
      return Switch(
        onChanged: _onChanged,
        value: widget.isOn,
        activeColor: Styles.primaryColor(),
        inactiveThumbColor: Styles.labelColor(),
      );
    }
  }

  void _onChanged(bool value) {
    if (widget.onChanged != null) {
      widget.onChanged(value);
    }
    if (widget.controller != null) {
      widget.controller.isOn = value;
    }

    setState(() {
      widget.isOn = value;
    });
  }
}

class SwitcherController {
  bool isOn = false;
}
