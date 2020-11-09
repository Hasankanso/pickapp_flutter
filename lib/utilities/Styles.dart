import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

headerTextStyle(context, {isValue, isTitle}) {
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
