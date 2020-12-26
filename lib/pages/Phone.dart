import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/CheckUserExist.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/PopUp.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Phone extends StatefulWidget {
  User _user;
  Phone(this._user);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final _formKey = GlobalKey<FormState>();
  bool _isForceRegister = false;
  bool _userHasBeenChecked = false;
  TextEditingController _phone = TextEditingController();
  TextEditingController _code = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget._user.phone != null) {
      _phone.text = (widget._user.phone)
          .split("+" + widget._user.person.countryInformations.code)[1];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (!Validation.isNullOrEmpty(_phone.text)) {
      widget._user.phone = "+" + _code.text + _phone.text;
    }
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _code.text = widget._user.person.countryInformations.code;
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Phone"),
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
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      controller: _code,
                      textAlign: TextAlign.end,
                      enableInteractiveSelection: false,
                      showCursor: false,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Code"),
                        labelStyle: Styles.labelTextStyle(),
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
                        LengthLimitingTextInputFormatter(
                            widget._user.person.countryInformations.digits),
                      ],
                      onChanged: (value) => _userHasBeenChecked = false,
                      controller: _phone,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        String valid = Validation.validate(value, context);
                        String phone = Validation.isPhoneNumber(context, value);
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
                text_key: "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    widget._user.phone = "+" + _code.text + _phone.text;
                    if (!_userHasBeenChecked) {
                      User checkUser = User(phone: widget._user.phone);
                      Request<bool> request = CheckUserExist(checkUser);
                      await request.send(_checkUserExistResponse);
                    } else {
                      Navigator.of(context).pushNamed('/Phone2',
                          arguments: [widget._user, _isForceRegister]);
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkUserExistResponse(bool userExist, int statusCode, String message) {
    if (statusCode != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      _userHasBeenChecked = true;
      if (userExist == true) {
        PopUp.areYouSure(
          Lang.getString(context, "Skip"),
          Lang.getString(context, "Login"),
          Lang.getString(context, "Account_with_phone") +
              _code.text +
              _phone.text +
              Lang.getString(context, "Exist_desc"),
          Lang.getString(context, "Account_already_exist"),
          Styles.primaryColor(),
          (bool) => bool ? _skip() : _login(),
          interest: false,
          hideClose: true,
        ).confirmationPopup(context);
      } else {
        Navigator.of(context)
            .pushNamed('/Phone2', arguments: [widget._user, _isForceRegister]);
      }
    }
  }

  _login() {
    Navigator.of(context).pushNamed('/Login');
  }

  _skip() {
    _isForceRegister = true;
    Navigator.of(context)
        .pushNamed('/Phone2', arguments: [widget._user, _isForceRegister]);
  }
}
