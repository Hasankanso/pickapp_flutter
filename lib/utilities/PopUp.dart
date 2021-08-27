import 'package:flutter/material.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopUp {
  String positiveText, negativeText, title, desc;
  Function(bool) response;
  Function close;
  bool hideClose;
  Widget content;
  Color titleColor,
      positiveBackgroundColor,
      negativeBackgroundColor,
      mainColor,
      positiveTextColor,
      negativeTextColor;
  BoxBorder positiveBorder, negativeBorder;

  final _formKey = GlobalKey<FormState>();

  PopUp.areYouSure(
      this.positiveText, this.negativeText, this.desc, this.title, this.mainColor, this.response,
      {bool highlightYes = true, this.hideClose = false, this.close, this.content}) {
    if (highlightYes) {
      positiveTextColor = Colors.white;
      negativeTextColor = mainColor;

      positiveBackgroundColor = mainColor;
      negativeBackgroundColor = Colors.transparent;

      positiveBorder = null;
      negativeBorder = Border.all(width: 2.0, color: mainColor);
    } else {
      positiveTextColor = mainColor;
      negativeTextColor = Colors.white;
      positiveBackgroundColor = Colors.transparent;
      negativeBackgroundColor = mainColor;

      positiveBorder = Border.all(width: 2.0, color: mainColor);
      negativeBorder = null;
    }

    this.titleColor = mainColor;
    this.desc = desc;
  }

  confirmationPopup(BuildContext dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: !hideClose,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: mainColor),
      descStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "$title",
        desc: "$desc",
        closeFunction: close,
        content: Form(key: _formKey, child: content != null ? content : Container()),
        buttons: [
          DialogButton(
            border: positiveBorder,
            child: Text(
              "$positiveText",
              style: TextStyle(color: positiveTextColor, fontSize: Styles.fontSize()),
            ),
            color: positiveBackgroundColor,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                Navigator.pop(dialogContext);
                response(true);
              }
            },
          ),
          DialogButton(
            border: negativeBorder,
            child: Text(
              "$negativeText",
              style: TextStyle(color: negativeTextColor, fontSize: Styles.fontSize()),
            ),
            color: negativeBackgroundColor,
            onPressed: () {
              Navigator.pop(dialogContext);
              response(false);
            },
          )
        ]).show();
  }
}
