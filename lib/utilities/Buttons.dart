import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/ResponsiveRow.dart';

class MainButton extends StatelessWidget {
  String text_key;
  Function onPressed;
  double _radius = 8;

  MainButton({this.text_key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ResponsiveRow(
      children: [
        CupertinoButton(
          child: Text(
            Lang.getString(context, text_key),
            style: Styles.buttonTextStyle(context),
          ),
          color: Styles.primaryColor(),
          onPressed: onPressed,
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
        )
      ],
    );
  }
}
