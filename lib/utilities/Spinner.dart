import 'package:flutter/material.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Styles.dart';

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Cache.darkTheme ? Styles.primaryColor() : null,
    );
  }
}
