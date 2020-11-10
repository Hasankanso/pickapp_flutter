import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/SameSizeResponsiveRow.dart';

class MainButton extends StatelessWidget {
  String text_key;
  Function onPressed;
  double _radius = 8;

  MainButton({this.text_key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (App.isIphone()) {
      return SameSizeResponsiveRow(
        children: [
          CupertinoButton(
            child: Text(
              Lang.getString(context, text_key),
              style: Styles.titleTextStyle(context),
            ),
            color: Styles.primaryColor(),
            onPressed: onPressed,
            borderRadius: BorderRadius.all(Radius.circular(_radius)),
          )
        ],
      );
    } else {
      return SameSizeResponsiveRow(
        children: [
          FlatButton(
              onPressed: onPressed,
              color: Styles.primaryColor(),
              child: Text(
                Lang.getString(context, text_key),
                style: Styles.titleTextStyle(context),
              ))
        ],
      );
    }
  }
}
