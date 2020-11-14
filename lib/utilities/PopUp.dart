import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PopUp extends StatelessWidget {
  final String btn1Text, btn2Text, title, desc;
  final Function a;
  final Function b;
  final Color titleColor, btn1Color, btn2Color;

  PopUp.name(this.btn1Text, this.btn2Text, this.title, this.desc, this.a,
      this.b, this.titleColor, this.btn1Color, this.btn2Color);

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
              "$btn1Text",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            color: btn1Color,
            onPressed: () {
              Navigator.pop(dialogContext);
              a();
            },
          ),
          DialogButton(
            child: Text(
              "$btn2Text",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            color: btn2Color,
            onPressed: () {
              Navigator.pop(dialogContext);
              b();
            },
          )
        ]).show();
  }
}
