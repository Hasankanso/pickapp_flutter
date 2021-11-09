import 'package:flutter/material.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class TermAndConditions extends StatefulWidget {
  @override
  _TermAndConditions createState() => _TermAndConditions();
}

class _TermAndConditions extends State<TermAndConditions> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Terms_&_Conditions"),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        VerticalSpacer(height: 20),
      ])),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            DifferentSizeResponsiveRow(
              children: [],
            ),
            VerticalSpacer(height: 20)
          ],
        ),
      ),
    );
  }
}
