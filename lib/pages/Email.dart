import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/requests/ChangeEmail.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

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
    if (App.handleErrors(context, code, message)) {
      return;
    }

    App.user.email = p1;
    Cache.setUser(App.user);

    //CustomToast().showSuccessToast(Lang.getString(context, "Email_confirmation_pending"));
  }
}
