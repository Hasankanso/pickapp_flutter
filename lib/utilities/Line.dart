import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  bool margin;
  Line({this.margin = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin
          ? EdgeInsets.symmetric(
              horizontal: 8.0,
            )
          : null,
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade300,
    );
  }
}
