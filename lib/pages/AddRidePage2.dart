import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Switcher.dart';

class AddRidePage2 extends StatefulWidget {
  @override
  _AddRidePage2State createState() => _AddRidePage2State();
}

class _AddRidePage2State extends State<AddRidePage2> {
  SwitcherController switcherController = SwitcherController();
  bool stopOver = false;
  bool kidsSeat = false;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Add_Ride"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 50,
              child: Row(children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 6,
                  child: Text(
                    "Do you have kids seat ?",
                    style: Styles.labelTextStyle(),
                  ),
                ),
                Expanded(
                    flex: 3,
                    child: Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      value: kidsSeat,
                      onChanged: (bool newValue) {
                        setState(() {
                          kidsSeat = newValue;
                        });
                      },
                    )),
                Expanded(flex: 1, child: SizedBox()),
              ]),
            ),
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 50,
              child: Row(children: [
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 6,
                  child: Text(
                    "Do you want to stop over ?",
                    style: Styles.labelTextStyle(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Checkbox(
                    value: stopOver,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onChanged: (bool newValue) {
                      setState(() {
                        stopOver = newValue;
                      });
                    },
                  ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ]),
            ),
            VerticalSpacer(
              height: 20,
            ),
            Visibility(
              visible: stopOver,
              child: ResponsiveWidget.fullWidth(
                height: 50,
                child: Row(children: [
                  Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 6,
                    child: Text(
                      "How much time you need ?",
                      style: Styles.labelTextStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "       /min",
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Expanded(flex: 1, child: SizedBox()),
                ]),
              ),
            ),
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget(
              width: 270,
              height: 150,
              child: TextField(
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 15,
              ),
            ),
            VerticalSpacer(
              height: 180,
            ),
          ],
        ),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Next",
                onPressed: () {
                  Navigator.of(context).pushNamed("/AddRidePage3");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
