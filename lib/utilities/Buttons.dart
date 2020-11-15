import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/ResponsiveRow.dart';
import 'package:pickapp/utilities/ResponsiveWidget.dart';

class MainButton extends StatelessWidget {
  String text_key;
  Function onPressed;
  double _radius = 8;

  MainButton({this.text_key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      width: 270,
      height: 43,
      child: (InkWell(
        onTap: () {},
        child: CupertinoButton(
          padding: EdgeInsets.fromLTRB(
              0, App.mediaQuery.size.height * 0.0205, 0,
              App.mediaQuery.size.height * 0.0205),
          child: Text(
            Lang.getString(context, text_key),
            style: Styles.buttonTextStyle(),
          ),
          pressedOpacity: 0.7,
          color: Styles.primaryColor(),
          onPressed: onPressed,
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
        ),
      )),
    );
  }
}
