import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

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
                      image: AssetImage("lib/images/background.jpg"),
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
                                print(App.person);

//                                Navigator.of(context).pushNamed('/Login');
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
