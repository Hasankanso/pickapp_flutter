import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Styles {
  static double _fontSize, _titleFontSize, _subValueFontSize;
  static double _largeSize, _mediumSize, _smallSize;
  static double _smallAppBarHeight = kToolbarHeight,
      _mediumAppBarHeight = kToolbarHeight,
      _largetAppBarHeight =
          kToolbarHeight; //never use these variables in the code, only change their values.
  static ThemeMode _currentTheme = ThemeMode.system;

  static ThemeMode currentTheme() {
    return _currentTheme;
  }

  static void setTheme(ThemeMode theme) {
    _currentTheme = theme;
  }

  static setFontSizes(
      {double fontSize, double titleFontSize, double subValueFontSize}) {
    _fontSize = fontSize;
    _titleFontSize = titleFontSize;
    _subValueFontSize = subValueFontSize;
  }

  static setIconSizes({double largeSize, double mediumSize, double smallSize}) {
    _largeSize = largeSize;
    _mediumSize = mediumSize;
    _smallSize = smallSize;
  }

  static setAppBarHeights({small, double medium, double large}) {
    _smallAppBarHeight = small;
    _mediumAppBarHeight = medium;
    _largetAppBarHeight = large;
  }

  static get smallAppBarHeight => _smallAppBarHeight;

  static get mediumAppBarHeight => _mediumAppBarHeight;

  static get largetAppBarHeight => _largetAppBarHeight;

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

  static TextStyle labelTextStyle({bold = FontWeight.w400}) {
    return TextStyle(
      color: labelColor(),
      fontSize: _fontSize,
      fontWeight: bold,
    );
  }

  static TextStyle valueTextStyle({bold = FontWeight.w400}) {
    return TextStyle(
        color: valueColor(), fontSize: _fontSize, fontWeight: bold);
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

  //icons size navigationbottomicons ...
  static double largeIconSize() {
    return _largeSize;
  }

  static double mediumIconSize() {
    return _mediumSize;
  }

  static double smallIconSize() {
    return _smallSize;
  }
}
