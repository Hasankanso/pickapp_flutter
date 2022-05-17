import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
        appBar: MainAppBar(
          title: Lang.getString(context, "Privacy_Policy"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              VerticalSpacer(height: 20),
              ResponsiveRow(
                flex: 18,
                children: [
                  Text(Lang.getString(context, "Privacy_policy_text_1") +
                      App.appName +
                      ".\n\n" +
                      Lang.getString(context, "Privacy_policy_text_2") +
                      "\n\n" +
                      Lang.getString(context, "Privacy_policy_text_3") +
                      "\n\n" +
                      Lang.getString(context, "Privacy_policy_text_4") +
                      "\n\n" +
                      Lang.getString(context, "Privacy_policy_text_5") +
                      "\n\n" +
                      Lang.getString(context, "Privacy_policy_text_6") +
                      "\n\n" +
                      Lang.getString(context, "Privacy_policy_text_7") +
                      "\n\n" +
                      Lang.getString(context, "Privacy_policy_text_8") +
                      "\n\n"),
                ],
              ),
            ],
          ),
        ));
  }
}
