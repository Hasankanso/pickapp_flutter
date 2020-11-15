import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'App.dart';

class Styles {
  //for app bar
  static titleTextStyle() {
    return TextStyle(
      fontSize: titlefontSize(),
      color: secondaryColor(),
    );
  }

  //  button text or wherever background primary
  static buttonTextStyle() {
    return TextStyle(
      fontSize: fontSize(),
      color: secondaryColor(),
    );
  }

  //where color is primary
  static headerTextStyle() {
    return TextStyle(
      fontSize: fontSize(),
      color: primaryColor(),
    );
  }

  static subHeaderTextStyle() {
    return TextStyle(
      fontSize: fontSize(),
      color: secondaryColor(),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle labelTextStyle() {
    return TextStyle(
      color: labelColor(),
      fontSize: fontSize(),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle valueTextStyle() {
    return TextStyle(
        color: valueColor(),
        fontSize: App.mediaQuery.size.width * 0.043,
        fontWeight: FontWeight.w400);
  }
  static TextStyle subValueTextStyle() {
    return TextStyle(
        color: valueColor(),
        fontSize: App.mediaQuery.size.width * 0.034,
        fontWeight: FontWeight.w400);
  }

  static double titlefontSize() {
    return App.mediaQuery.size.width * 0.049;
  }

  static double fontSize() {
    return App.mediaQuery.size.width * 0.043;
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
  static double bigIconSize() {
    return App.mediaQuery.size.width * 0.075;
  }

  static double mediumIconSize() {
    return App.mediaQuery.size.width * 0.060;
  }

  static double smallIconSize() {
    return App.mediaQuery.size.width * 0.040;
  }
}
