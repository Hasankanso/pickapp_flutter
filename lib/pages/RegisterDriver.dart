import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/ForceRegisterPerson.dart';
import 'package:pickapp/requests/RegisterPerson.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class RegisterDriver extends StatefulWidget {
  bool isForceRegister;
  User user;
  String idToken;

  RegisterDriver({this.isForceRegister, this.user, this.idToken});

  @override
  _RegisterDriverState createState() => _RegisterDriverState();
}

class _RegisterDriverState extends State<RegisterDriver> {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Become_a_Driver"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          VerticalSpacer(height: 70),
          ResponsiveRow(
            widgetRealtiveSize: 20,
            children: [
              Text(
                Lang.getString(context, "Register_driver_message1"),
                style: Styles.labelTextStyle(bold: FontWeight.bold),
              ),
            ],
          ),
          ResponsiveRow(
            widgetRealtiveSize: 20,
            children: [
              Text(
                Lang.getString(context, "Register_driver_message2"),
                style: Styles.labelTextStyle(bold: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 110,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: false,
                text_key: "Next",
                onPressed: () {
                  widget.user.driver = Driver();
                  Navigator.of(context).pushNamed("/BecomeDriverRegister",
                      arguments: [
                        widget.user,
                        widget.isForceRegister,
                        widget.idToken
                      ]);
                },
              ),
            ),
            ResponsiveWidget.fullWidth(
              height: 50,
              child: DifferentSizeResponsiveRow(
                children: <Widget>[
                  Spacer(
                    flex: 2,
                  ),
                  Expanded(
                    flex: 11,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return WillPopScope(
                              onWillPop: () async => false,
                              child: Center(
                                child: Spinner(),
                              ),
                            );
                          },
                        );
                        widget.user.driver = null;
                        Request<User> registerRequest;
                        if (!widget.isForceRegister) {
                          registerRequest =
                              RegisterPerson(widget.user, widget.idToken);
                        } else {
                          registerRequest =
                              ForceRegisterPerson(widget.idToken, widget.user);
                        }
                        registerRequest.send(_registerResponse);
                      },
                      child: Text(
                        Lang.getString(context, "Register"),
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.w400,
                          color: (!Cache.darkTheme &&
                                  MediaQuery.of(context).platformBrightness !=
                                      Brightness.dark)
                              ? Styles.valueColor()
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user = u;
      await Cache.setUserCache(u);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      CustomToast().showSuccessToast(
          Lang.getString(context, "Email_confirmation_pending"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
