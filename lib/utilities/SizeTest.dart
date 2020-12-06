import 'package:flutter/material.dart';
import 'package:pickapp/utilities/Responsive.dart';

import 'MainAppBar.dart';

class SizeTest extends StatefulWidget {
  Widget body;
  double width, height;

  SizeTest({this.body, this.width, this.height});

  @override
  _TestScaffoldState createState() => _TestScaffoldState();
}

class _TestScaffoldState extends State<SizeTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: "Size Test"),
      body: GestureDetector(
          child: ResponsiveWidget(
              width: widget.width, height: widget.height, child: widget.body),
          onPanUpdate: (details) {
            setState(() {
              widget.width += details.delta.dx;
              widget.height += details.delta.dy;
            });
          }),
    );
  }
}
