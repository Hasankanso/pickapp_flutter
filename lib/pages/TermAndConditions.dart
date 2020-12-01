import 'package:flutter/material.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Responsive.dart';

class TermAndConditions extends StatefulWidget {
  @override
  _TermAndConditions createState() => _TermAndConditions();
}

class _TermAndConditions extends State<TermAndConditions> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Privacy_Policy"),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        VerticalSpacer(height: 20),
        ResponsiveRow(
            widgetRealtiveSize: 18,
            children: [Text("We will sell your data for less than one cent")]),
      ])),
      bottomNavigationBar: ResponsiveWidget.fullWidth(height: 80,
        child: Column(
          children: [
            DifferentSizeResponsiveRow(
              children: [
                Expanded(flex: 6, child: Text("Accept Terms & Conditions")),
                Expanded(
                  flex: 2,
                  child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      value: Cache.conditionAccepted,
                      onChanged: (bool newValue) {
                        if (newValue == false) {
                          PopUp.areYouSure(
                                  Lang.getString(context, "Yes"),
                                  Lang.getString(context, "No"),
                                  "Are you sure you want to leave us?",
                                  "Confirmation",
                                  (value) => setState(() {
                                        Cache.setConditionAccepted(!value);
                                      }),
                                  interest: false)
                              .confirmationPopup(context);
                        } else {
                          setState(() {
                            Cache.setConditionAccepted(true);
                          });
                        }
                      }),
                ),
              ],
            ), VerticalSpacer(height: 20)
          ],
        ),
      ),
    );
  }
}
