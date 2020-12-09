import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
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
  final _formKey = GlobalKey<FormState>();
  var _phone = TextEditingController();
  List<String> _countriesCodes = App.countriesInformationsCodes;
  var _countryCode = "961";

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
            VerticalSpacer(
              height: 20,
            ),
            ResponsiveWidget.fullWidth(
              height: 160,
              child: ResponsiveRow(
                children: [
                  FittedBox(
                    fit: BoxFit.contain,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("lib/images/Logo.png"),
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
                      flex: 10,
                      child: Align(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: "",
                              labelStyle: TextStyle(
                                  fontSize: 8, color: Colors.transparent)),
                          value: '$_countryCode',
                          validator: (val) {
                            String valid = Validation.validate(val, context);
                            if (valid != null) return valid;
                            return null;
                          },
                          onChanged: (String newValue) {
                            setState(() {
                              _countryCode = newValue;
                            });
                          },
                          items: _countriesCodes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 30,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Phone"),
                          labelStyle: Styles.labelTextStyle(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(App
                              .countriesInformations[
                                  _countryCode == "961" ? "Lebanon" : "Germany"]
                              .digits),
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
                text_key: "Next",
                isRequest: true,
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Request<String> request =
                        VerifyAccount("+" + _countryCode + _phone.text);
                    await request.send(respondAccountVerification);
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
                          Lang.getString(context, "New_to_PickApp?") + "\t",
                          style: Styles.labelTextStyle(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Register');
                          },
                          child: Text(
                            Lang.getString(context, "Register"),
                            style: Styles.headerTextStyle(underline: true),
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
      User user = User(phone: "+" + _countryCode + _phone.text);
      Navigator.of(context)
          .pushNamed('/LoginConfirmationCode', arguments: user);
      CustomToast()
          .showSuccessToast("Verification Code has been sent to: " + p1);
    }
  }
}
