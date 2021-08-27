import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Styles.dart';

class Switcher extends StatefulWidget {
  bool isOn = false;
  SwitcherController controller;
  void Function(bool) onChanged;
  bool isDisabled;

  Switcher({this.isOn, this.controller, this.onChanged, this.isDisabled = false});

  @override
  _SwitcherState createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.controller != null) {
      widget.controller.isOn == null
          ? widget.controller.isOn = widget.isOn
          : widget.isOn = widget.controller.isOn;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (App.isIphone()) {
      return CupertinoSwitch(
        value: widget.isOn,
        onChanged: !widget.isDisabled ? _onChanged : null,
        activeColor: Styles.primaryColor(),
      );
    } else {
      return Switch(
        onChanged: !widget.isDisabled ? _onChanged : null,
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
  bool isOn;
  SwitcherController({this.isOn = false});
}
