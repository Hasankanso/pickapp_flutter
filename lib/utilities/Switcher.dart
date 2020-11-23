import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';

class Switcher extends StatefulWidget {
  bool isOn = false;
  String title;
  SwitcherController controller;
  Switcher({this.isOn, this.controller, this.title});
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
      return Row(children: [
        Container(
          margin: EdgeInsets.only(
              right: ScreenUtil().setWidth(6), left: ScreenUtil().setWidth(6)),
          child: Text(
            widget.title,
            style: Styles.valueTextStyle(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(6)),
          child: CupertinoSwitch(
            value: widget.isOn,
            onChanged: (bool value) {
              setState(() {
                widget.isOn = value;
                widget.controller.isOn = value;
              });
            },
            activeColor: Styles.primaryColor(),
          ),
        ),
      ]);
    } else if (App.isAndroid()) {
      return Row(
        children: [
          Container(
            margin: EdgeInsets.only(
                right: ScreenUtil().setWidth(6),
                left: ScreenUtil().setWidth(6)),
            child: Text(
              widget.title,
              style: Styles.valueTextStyle(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(6)),
            child: Switch(
              onChanged: (value) {
                setState(() {
                  widget.isOn = value;
                  widget.controller.isOn = value;
                });
              },
              value: widget.isOn,
              activeColor: Styles.primaryColor(),
              inactiveThumbColor: Styles.labelColor(),
            ),
          ),
        ],
      );
    }
  }
}

class SwitcherController {
  bool isOn;
}
