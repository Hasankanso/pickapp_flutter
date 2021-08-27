import 'package:flutter/material.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/PopUp.dart';
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
        title: Lang.getString(context, "Privacy_Policy"),
      ),
      body: SingleChildScrollView(
          child: Column(children: [
        VerticalSpacer(height: 20),
        ResponsiveRow(flex: 18, children: [Text("we respect you")]),
      ])),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
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
                                  Colors.red,
                                  (value) => setState(() {
                                        Cache.setConditionAccepted(!value);
                                      }),
                                  highlightYes: true)
                              .confirmationPopup(context);
                        } else {
                          setState(() {
                            Cache.setConditionAccepted(true);
                          });
                        }
                      }),
                ),
              ],
            ),
            VerticalSpacer(height: 20)
          ],
        ),
      ),
    );
  }
}
