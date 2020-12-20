import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_button/flutter_progress_button.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

class MainButton extends StatelessWidget {
  String text_key;
  Function onPressed;
  double _radius = 8;
  bool isRequest;

  MainButton({this.text_key, this.onPressed, this.isRequest = false});

  @override
  Widget build(BuildContext context) {
    if (!isRequest) {
      return RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Styles.primaryColor(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius)),
        child: Text(Lang.getString(context, text_key),
            style: Styles.buttonTextStyle(), overflow: TextOverflow.visible),
        onPressed: onPressed,
      );
    } else {
      return ProgressButton(
        defaultWidget: Text(Lang.getString(context, text_key),
            style: Styles.buttonTextStyle(), overflow: TextOverflow.visible),
        progressWidget: CircularProgressIndicator(
          backgroundColor: !Cache.darkTheme
              ? Styles.secondaryColor()
              : Styles.primaryColor(),
        ),
        color: Styles.primaryColor(),
        borderRadius: _radius,
        onPressed: () async {
          await onPressed();
          return () {
            // Optional returns is returning a VoidCallback that will be called
            // after the animation is stopped at the beginning.
            // A best practice would be to do time-consuming task in [onPressed],
            // and do page navigation in the returned VoidCallback.
            // So that user won't missed out the reverse animation.
          };
        },
      );
    }
  }
}
