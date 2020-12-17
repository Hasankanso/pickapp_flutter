import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddRidePage2 extends StatefulWidget {
  final Ride rideInfo;

  const AddRidePage2({Key key, this.rideInfo}) : super(key: key);

  @override
  _AddRidePage2State createState() => _AddRidePage2State(rideInfo);
}

class _AddRidePage2State extends State<AddRidePage2> {
  final Ride rideInfo;

  _AddRidePage2State(this.rideInfo);

  bool stopOver = false;
  bool kidsSeat = false;
  final timeController = TextEditingController();
  final descController = TextEditingController();

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
                Spacer(),
                Expanded(
                  flex: 6,
                  child: Text(
                    Lang.getString(context, "Do_You_Have_Kids_Seat"),
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
                Spacer(),
              ]),
            ),
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 50,
              child: Row(children: [
                Spacer(),
                Expanded(
                  flex: 6,
                  child: Text(
                    Lang.getString(context, "Do_You_Want_To_Stop_Over"),
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
                Spacer(),
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
                  Spacer(),
                  Expanded(
                    flex: 6,
                    child: Text(
                      Lang.getString(context, "How_Much_Time_You_Need"),
                      style: Styles.labelTextStyle(),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: Lang.getString(context, "/Min"),
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Spacer(),
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
                controller: descController,
                decoration: InputDecoration(
                    labelText: Lang.getString(context, "Description")),
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
                  bool isStoping = stopOver;
                  bool isKidsSeat = kidsSeat;
                  String desc = descController.text;
                  rideInfo.kidSeat = isKidsSeat;
                  rideInfo.comment = desc;
                  if (isStoping == true && timeController.text != "") {
                    int time = int.parse(timeController.text);
                    rideInfo.stopTime = time;
                    Navigator.of(context)
                        .pushNamed("/AddRidePage3", arguments: rideInfo);
                  } else if (isStoping == false) {
                    Navigator.of(context)
                        .pushNamed("/AddRidePage3", arguments: rideInfo);
                  } else
                    CustomToast().showErrorToast("Enter the stopping time !");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
