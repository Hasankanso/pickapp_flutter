import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as Svg;
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/LanguagesDropDown.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class LoginRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Center(
          child: Column(
            children: [
              VerticalSpacer(
                height: 150,
              ),
              Image(
                  image: Svg.Svg('lib/images/voomcar_logo.svg',
                      size: const Size(210 * 1.4, 38.8 * 1.4))),
              VerticalSpacer(
                height: 220,
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
                        textKey: "Login",
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
                        textKey: "Register",
                        onPressed: () {
                          Navigator.of(context).pushNamed('/Register');
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                  child: LanguagesDropdown(
                spaced: false,
              )),
            ],
          ),
        )),
      ),
    );
  }
}
