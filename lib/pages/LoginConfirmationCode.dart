import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/Login.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class LoginConfirmationCode extends StatelessWidget {
  final _form = GlobalKey<FormState>();
  User _user;
  LoginConfirmationCode(this._user);
  TextEditingController _code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Login",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ResponsiveWidget.fullWidth(
            height: 90,
            child: DifferentSizeResponsiveRow(
              children: [
                Spacer(
                  flex: 1,
                ),
                Form(
                  key: _form,
                  child: Expanded(
                    flex: 10,
                    child: TextFormField(
                      controller: _code,
                      validator: (value) {
                        String valid = Validation.validate(value, context);
                        if (valid != null) return valid;
                        if (value.length != 5)
                          return Validation.invalid(context);
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Code"),
                        hintText: "4#Ao",
                        labelStyle: Styles.labelTextStyle(),
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Login",
                isRequest: true,
                onPressed: () {
                  if (_form.currentState.validate()) {
                    _user.verificationCode = _code.text;
                    Request<User> request = Login(_user);
                    request.send((u, code, message) =>
                        response(u, code, message, context));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void response(User u, int code, String message, context) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      App.user = u;
      //todo cache user
      //Cache.SetUser(u);
      App.isLoggedIn = true;
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      Navigator.pop(context);
    }
  }
}
