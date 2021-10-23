import 'package:flutter/material.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class LoginRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "PickApp",
      ),
      body: Center(
          child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "lib/images/login_register_background_logo.png"),
                      fit: BoxFit.cover)),
              child: Center(
                child: Column(
                  children: [
                    VerticalSpacer(
                      height: 370,
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveWidget(
                            width: 270,
                            height: 50,
                            child: MainButton(
                              text_key: "Login",
                              onPressed: () {
                                Navigator.of(context).pushNamed('/Login');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ResponsiveWidget(
                            width: 270,
                            height: 50,
                            child: MainButton(
                              text_key: "Register",
                              onPressed: () {
                                Navigator.of(context).pushNamed('/Register');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
