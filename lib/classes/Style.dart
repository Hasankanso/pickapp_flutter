import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Style {

  static TextStyle headerTextStyle(context, {isValue, isTitle}) {
    final _deviceSize = MediaQuery.of(context);
    if (isValue == null && isTitle == null)
      return TextStyle(fontSize: _deviceSize.size.width * 0.049);
    else if (isValue == true)
      return TextStyle(
          color: Colors.blue, fontSize: _deviceSize.size.width * 0.06);
    else if (isTitle == true)
      return TextStyle(
          color: Colors.grey, fontSize: _deviceSize.size.width * 0.06);
  }


  static TextStyle secondStyle(context){
    final _deviceSize = MediaQuery.of(context);
    return TextStyle(color : secondColor(), fontSize: _deviceSize.size.width * 0.049 );
  }

  static Color mainColor() {
    return Colors.blue;
  }

  static Color secondColor() {
    return Colors.white;
  }

  static Color labelColor() {
    return Colors.grey[300];
  }

  static Color backgroundColor() {
    return Colors.amber[50];
  }

}
