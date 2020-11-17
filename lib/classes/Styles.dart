import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'App.dart';

class Styles {

  static double _fontSize, _titleFontSize,  _subValueFontSize;

  static setFontSizes({double fontSize, double titleFontSize, double subValueFontSize}){
    _fontSize = fontSize;
    _titleFontSize = titleFontSize;
    _subValueFontSize = subValueFontSize;
  }

  //for app bar
  static titleTextStyle() {
    return TextStyle(
      fontSize: _titleFontSize,
      color: secondaryColor(),
    );
  }

  //  button text or wherever background primary
  static buttonTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      color: secondaryColor(),
    );
  }

  //where color is primary
  static headerTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      color: primaryColor(),
    );
  }

  static subHeaderTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      color: secondaryColor(),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle labelTextStyle() {
    return TextStyle(
      color: labelColor(),
      fontSize: _fontSize,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle valueTextStyle() {
    return TextStyle(
        color: valueColor(),
        fontSize: _fontSize,
        fontWeight: FontWeight.w400);
  }
  static TextStyle subValueTextStyle() {
    return TextStyle(
        color: valueColor(),
        fontSize: _subValueFontSize,
        fontWeight: FontWeight.w400);
  }

  static double titleFontSize() {
    return _titleFontSize;
  }

  static double fontSize() {
    return _fontSize;
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
