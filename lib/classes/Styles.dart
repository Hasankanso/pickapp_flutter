import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pickapp/classes/screenutil.dart';

class Styles {
  static double _fontSize, _titleFontSize, _subValueFontSize;
  static double _largeSize, _mediumSize, _subMediumSize, _smallSize;
  static double _smallAppBarHeight = kToolbarHeight,
      _mediumAppBarHeight = kToolbarHeight,
      _largetAppBarHeight =
          kToolbarHeight; //never use these variables in the code, only change their values.
  static ThemeMode _currentTheme = ThemeMode.system;

  static String femaleIcon = " \u{2640}";
  static String maleIcon = " \u{2642}";
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

  static setIconSizes(
      {double largeSize,
      double mediumSize,
      double subMediumSize,
      double smallSize}) {
    _largeSize = largeSize;
    _mediumSize = mediumSize;
    _subMediumSize = subMediumSize;
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
  static buttonTextStyle({size}) {
    double realSize = size == null ? _fontSize : ScreenUtil().setSp(size);
    return TextStyle(
      fontSize: realSize,
      color: secondaryColor(),
    );
  }

  //where color is primary
  static headerTextStyle({bool underline = false}) {
    return TextStyle(
        fontSize: _fontSize,
        color: primaryColor(),
        decoration: underline ? TextDecoration.underline : null);
  }

  static subHeaderTextStyle() {
    return TextStyle(
      fontSize: _fontSize,
      color: secondaryColor(),
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle labelTextStyle({bold = FontWeight.w400, size}) {
    double realSize = size == null ? _fontSize : ScreenUtil().setSp(size);

    return TextStyle(
      color: labelColor(),
      fontSize: realSize,
      fontWeight: bold,
    );
  }

  static TextStyle valueTextStyle(
      {bold = FontWeight.w400, bool underline = false, color, int size}) {
    double realSize = size == null ? _fontSize : ScreenUtil().setSp(size);

    return TextStyle(
      fontSize: realSize,
      fontWeight: bold,
      decoration: underline ? TextDecoration.underline : null,
      color: color,
    );
  }

  static TextStyle subValueTextStyle({color}) {
    return TextStyle(
        fontSize: _subValueFontSize, fontWeight: FontWeight.w400, color: color);
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

  //light primary color of app
  static Color lightPrimaryColor() {
    return Colors.lightBlue;
  }

  static Color highlitedPrimary() {
    return Colors.blue[300];
  }

  static Color secondaryColor() {
    return Colors.white;
  }

  static Color labelColor() {
    return Colors.grey;
  }

  static Color lightLabelColor() {
    return Colors.grey.shade400;
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

  static double subMediumIconSize() {
    return _subMediumSize;
  }

  static double smallIconSize() {
    return _smallSize;
  }
}
