import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/Localizations.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Lang.getString(context, "settings")),
        ),
        body: Column(
          children: [TextField()],
        ));
  }
}
