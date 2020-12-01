import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopUp extends StatelessWidget {
  String positiveText, negativeText, title, desc;
  Function(bool) response;
  Color titleColor, positiveColor, negativeColor;
  Color positiveTextColor = Colors.white;

  PopUp.areYouSure(this.positiveText, this.negativeText, this.desc, this.title, this.response,
      {bool interest = true}) {

    if (interest) {
      titleColor = Styles.primaryColor();
      positiveColor = Styles.primaryColor();
      negativeColor = Colors.white;
    } else {
      titleColor = Colors.red;
      positiveTextColor = Colors.red;
      positiveColor = Colors.white;
      negativeColor = Styles.primaryColor();
    }
    this.desc = desc;
  }

  PopUp.name(this.positiveText, this.negativeText, this.title, this.desc,
      this.response, this.titleColor, this.positiveColor, this.negativeColor);

  @override
  Widget build(BuildContext context) {
    return confirmationPopup(context);
  }

  confirmationPopup(BuildContext dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 18, color: Colors.red),
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
            child: Text(
              "$negativeText",
              style: TextStyle(color: Colors.white, fontSize: 18),
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
