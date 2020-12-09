import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/requests/VerifyAccount.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _phone = TextEditingController();
  var _code = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Login",
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ResponsiveWidget.fullWidth(
              height: 160,
              child: ResponsiveRow(
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("lib/images/adel.png"),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: ResponsiveWidget.fullWidth(
                height: 90,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Spacer(
                      flex: 1,
                    ),
                    Expanded(
                      flex: 15,
                      child: TextFormField(
                        controller: _code,
                        decoration: InputDecoration(
                          labelText: 'Code',
                          labelStyle: Styles.labelTextStyle(),
                          hintText: "961",
                        ),
                        minLines: 1,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          String valid = Validation.validate(value, context);
                          if (valid != null) return valid;
                          return null;
                        },
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: Styles.labelTextStyle(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _phone,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          String valid = Validation.validate(value, context);
                          String phone =
                              Validation.isPhoneNumber(context, value);
                          if (valid != null)
                            return valid;
                          else if (phone != null) return phone;
                          return null;
                        },
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
              ),
            )
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
                text_key: "Login",
                isRequest: true,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Request<String> request =
                        new VerifyAccount("+" + _code.text + _phone.text);
                    request.send(respondAccountVerification);
                  }
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
                    child: Row(
                      children: [
                        Text(
                          'New to PickApp ?  ',
                          style: Styles.labelTextStyle(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/signup');
                          },
                          child: Text(
                            'Register',
                            style: Styles.valueTextStyle(underline: true),
                          ),
                        )
                      ],
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

  respondAccountVerification(String p1, int code, String error) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(error);
    } else {
      Navigator.of(context).pushNamed('/LoginConfirmationCode');
      CustomToast()
          .showSuccessToast("Verification Code has been sent to: " + p1);
    }
  }
}
