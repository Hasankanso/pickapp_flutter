import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/ChangeEmail.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Email extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  var _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _email.text = App.user.email;
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Email"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveWidget.fullWidth(
              height: 100,
              child: DifferentSizeResponsiveRow(
                children: [
                  Expanded(
                    flex: 10,
                    child: TextFormField(
                      controller: _email,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Email"),
                        hintText: Lang.getString(context, "Email_hint"),
                        labelStyle: Styles.labelTextStyle(),
                        hintStyle: Styles.labelTextStyle(),
                      ),
                      style: Styles.valueTextStyle(),
                      validator: (value) {
                        String valid = Validation.validate(value, context);
                        String email = Validation.isEmail(context, value);
                        if (valid != null) return valid;
                        if (email != null) return email;
                        return null;
                      },
                    ),
                  ),
                ],
              ),
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
                isRequest: true,
                text_key: "Save",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Request<String> request = ChangeEmail(_email.text);
                    await request.send((value, code, message) =>
                        _response(value, code, message, context));
                    print(1);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _response(String p1, int code, String message, context) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      final userBox = Hive.box("user");
      User cacheUser = App.user;
      cacheUser.person.rates = null;
      if (App.user.driver != null) {
        cacheUser.driver.regions = null;
      }
      cacheUser.email = p1;
      await userBox.put(0, cacheUser);

      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }
}
