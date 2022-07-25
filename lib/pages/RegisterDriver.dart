import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Driver.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/repository/user/user_repository.dart';
import 'package:just_miles/requests/ForceRegisterPerson.dart';
import 'package:just_miles/requests/RegisterPerson.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Spinner.dart';

class RegisterDriver extends StatefulWidget {
  User user;

  RegisterDriver({this.user});

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            VerticalSpacer(height: 70),
            ResponsiveRow(
              flex: 20,
              children: [
                Text(
                  Lang.getString(context, "Register_driver_message1"),
                  style: Styles.labelTextStyle(bold: FontWeight.bold),
                ),
              ],
            ),
            ResponsiveRow(
              flex: 20,
              children: [
                Text(
                  Lang.getString(context, "Register_driver_message2"),
                  style: Styles.labelTextStyle(bold: FontWeight.bold),
                )
              ],
            ),
            VerticalSpacer(
              height: 80,
            ),
            ResponsiveWidget.fullWidth(
              height: 250,
              child: DifferentSizeResponsiveRow(
                children: [
                  Spacer(
                    flex: 8,
                  ),
                  Expanded(
                    flex: 60,
                    child: MainNativeAd(),
                  ),
                  Spacer(
                    flex: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
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
                textKey: "Become_a_driver",
                onPressed: () {
                  widget.user.driver = Driver();
                  App.setCountriesComponent([
                    widget.user.person.countryInformations.countryComponent
                  ]);
                  Navigator.of(context)
                      .pushNamed("/BecomeDriverRegister", arguments: [
                    widget.user,
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
                        _registerRequest();
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

  Future<void> _registerRequest() async {
    Request<User> registerRequest;

    //get device token before registering
    String messagingToken = await FirebaseMessaging.instance.getToken();
    await widget.user.person.uploadImage();

    widget.user.person.deviceToken = messagingToken;

    if (!widget.user.isForceRegister) {
      registerRequest = RegisterPerson(widget.user);
    } else {
      registerRequest = ForceRegisterPerson(widget.user);
    }
    registerRequest.send(_registerResponse);
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (App.handleErrors(context, code, message)) {
      Navigator.pop(context);
      return;
    }

    App.user = u;
    await UserRepository().updateUser(u);

    await Cache.setCountriesList(
        [App.person.countryInformations.countryComponent]);
    App.setCountriesComponent(
        [App.person.countryInformations.countryComponent]);
    App.isDriverNotifier.value = false;
    App.user.driver = null;

    App.isLoggedInNotifier.value = true;

    CustomToast().showSuccessToast(Lang.getString(context, "Welcome_Voomcar"));
    // CustomToast().showSuccessToast(
    //     Lang.getString(context, "Email_confirmation_pending"));
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
