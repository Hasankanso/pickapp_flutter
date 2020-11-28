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
  bool rememberMe = false;
  bool show=false;

  void _onRememberMeChanged(bool newValue) => setState(() {
    rememberMe = newValue;

    if (rememberMe) {
     show=true;
    } else {

    show=false;
    }
  });
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
                    child: Switcher(
                      isOn: false,
                      controller: switcherController,
                    )),
                Expanded(flex: 1, child: SizedBox()),
              ]),
            ),
            VerticalSpacer(height: 20,),
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
                        value: rememberMe,
                        onChanged: _onRememberMeChanged
                    ),
                ),
                Expanded(flex: 1, child: SizedBox()),
              ]),
            ),
            VerticalSpacer(height: 20,),

            Visibility(
              visible: show,
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
                        decoration: InputDecoration(
                          hintText: "       /min"
                        ),
                      ),),
                  Expanded(flex: 1, child: SizedBox()),
                ]),
              ),
            ),
            VerticalSpacer(height: 20,),
            ResponsiveWidget(
              width: 270,
              height: 150,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Description"
                ),
                maxLines: 15,
              ),
            ),
            VerticalSpacer(height: 180,),
            ResponsiveWidget(
              width: 270,
              height: 53,
              child: MainButton(
                text_key: "Next",
                onPressed: () {
                  Navigator.of(context).pushNamed("/AddRidePage2");

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
