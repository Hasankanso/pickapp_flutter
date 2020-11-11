import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Styles {
  //for app bar
  static titleTextStyle(context) {
    return TextStyle(
      fontSize: titlefontSize(context),
      color: secondaryColor(),
    );
  }

  //  button text or wherever background primary
  static buttonTextStyle(context) {
    return TextStyle(
      fontSize: fontSize(context),
      color: secondaryColor(),
    );
  }

  //where color is primary
  static headerTextStyle(context) {
    return TextStyle(fontSize: fontSize(context), color: primaryColor());
  }

  static TextStyle labelTextStyle(context) {
    return TextStyle(
        color: labelColor(),
        fontSize: fontSize(context),
        fontWeight: FontWeight.w400);
  }

  static TextStyle valueTextStyle(context) {
    final _deviceSize = MediaQuery.of(context);
    return TextStyle(
        color: valueColor(),
        fontSize: _deviceSize.size.width * 0.043,
        fontWeight: FontWeight.w400);
  }

  static double titlefontSize(context) {
    final _deviceSize = MediaQuery.of(context);
    return _deviceSize.size.width * 0.049;
  }

  static double fontSize(context) {
    final _deviceSize = MediaQuery.of(context);
    return _deviceSize.size.width * 0.043;
  }

  //primary color of app
  static Color primaryColor() {
    return Colors.blue;
  }

  static Color secondaryColor() {
    return Colors.white;
  }

  static Color labelColor() {
    return Colors.grey;
  }

  static Color valueColor() {
    return Colors.black;
  }

  static Color backgroundColor() {
    return Colors.white;
  }

  //icons size navigationbottomicons ...
  static double primarySize(context) {
    final _deviceSize = MediaQuery.of(context);
    return _deviceSize.size.width * 0.075;
  }

  static double secondaryIconSize(context) {
    final _deviceSize = MediaQuery.of(context);
    return _deviceSize.size.width * 0.060;
  }
}
