import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Styles {
  //for app bar, and button text or wherever background primary
  static titleTextStyle(context) {
    final _deviceSize = MediaQuery.of(context);
    return TextStyle(
        fontSize: _deviceSize.size.width * 0.049, color: secondaryColor());
  }

  static TextStyle labelTextStyle(context) {
    final _deviceSize = MediaQuery.of(context);
    return TextStyle(
        color: labelColor(),
        fontSize: _deviceSize.size.width * 0.06,
        fontWeight: FontWeight.w400);
  }

  static TextStyle valueTextStyle(context) {
    final _deviceSize = MediaQuery.of(context);
    return TextStyle(
        color: valueColor(),
        fontSize: _deviceSize.size.width * 0.06,
        fontWeight: FontWeight.w400);
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
  static double iconSize(context) {
    final _deviceSize = MediaQuery.of(context);
    return _deviceSize.size.width * 0.075;
  }
}
