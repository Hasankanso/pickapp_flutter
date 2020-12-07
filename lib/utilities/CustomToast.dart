import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pickapp/classes/Styles.dart';

class CustomToast {
  void showShortToast(String msg, {Color backgroundColor = Colors.black54}) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: backgroundColor,
        fontSize: Styles.fontSize(),
        textColor: Colors.white);
  }

  void showLongToast(String msg, {Color backgroundColor = Colors.black54}) {
    Fluttertoast.showToast(
        backgroundColor: backgroundColor,
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        fontSize: Styles.fontSize(),
        textColor: Colors.white);
  }

  void cancelToast() {
    Fluttertoast.cancel();
  }
}
