import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopUp {
  String positiveText, negativeText, title, desc;
  Function(bool) response;
  Color titleColor,
      positiveColor,
      negativeColor,
      buttonColor,
      positiveTextColor,
      negativeTextColor;

  PopUp.areYouSure(this.positiveText, this.negativeText, this.desc, this.title,
      this.buttonColor, this.response,
      {bool interest = true}) {
    if (interest) {
      titleColor = buttonColor;
      positiveColor = buttonColor;
      negativeColor = Colors.transparent;
      negativeTextColor = buttonColor;
      positiveTextColor = Colors.white;
    } else {
      titleColor = buttonColor;
      positiveTextColor = buttonColor;
      positiveColor = Colors.transparent;
      negativeColor = buttonColor;
      negativeTextColor = Colors.white;
    }
    this.desc = desc;
  }

  confirmationPopup(BuildContext dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: buttonColor),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "$title",
        desc: "$desc",
        buttons: [
          DialogButton(
            border: Border.all(width: 2.0, color: buttonColor),
            child: Text(
              "$positiveText",
              style: TextStyle(color: positiveTextColor, fontSize: 18),
            ),
            color: positiveColor,
            onPressed: () {
              Navigator.pop(dialogContext);
              response(true);
            },
          ),
          DialogButton(
            //   border:Border.all(width: 2.0, color: buttonColor),
            child: Text(
              "$negativeText",
              style: TextStyle(color: negativeTextColor, fontSize: 18),
            ),
            color: negativeColor,
            onPressed: () {
              Navigator.pop(dialogContext);
              response(false);
            },
          )
        ]).show();
  }
}
