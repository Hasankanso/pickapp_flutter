import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Person.dart';
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
  TextEditingController _phone = TextEditingController();
  TextEditingController _code = TextEditingController();
  List<String> _countriesCodes = App.countriesInformationsCodes;
  var _countryCode = "961";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget._user != null && widget._user.phone != null) {
      _phone.text = (widget._user.phone)
          .split("+" + widget._user.person.countryInformations.code)[1];
    }
  }

  @override
  void dispose() {
    if (widget._user != null && !Validation.isNullOrEmpty(_phone.text)) {
      widget._user.phone = "+" + _code.text + _phone.text;
    }
    _phone.dispose();
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._user != null) {
      _code.text = widget._user.person.countryInformations.code;
    }
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
                  Visibility(
                    visible: widget._user == null,
                    child: Expanded(
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
                  ),
                  Visibility(
                    visible: widget._user != null,
                    child: Expanded(
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
                        LengthLimitingTextInputFormatter(widget._user != null
                            ? widget._user.person.countryInformations.digits
                            : App.getCountryInfo(_countryCode).digits),
                      ],
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
                    if (widget._user != null) {
                      String phone = "+" + _code.text + _phone.text;
                      if (widget._user.phone != phone) {
                        widget._user.isExistChecked = false;
                        await _openSecondPage(phone);
                      } else if (widget._user.idToken != null) {
                        Navigator.of(context).pushNamed('/RegisterDetails',
                            arguments: [widget._user, _isForceRegister]);
                      } else {
                        await _openSecondPage(phone);
                      }
                    } else {
                      if (App.user.phone == "+" + _countryCode + _phone.text) {
                        return CustomToast().showErrorToast("+" +
                            _countryCode +
                            _phone.text +
                            Lang.getString(context, "Same_phone"));
                      }
                      Person p = Person(
                          countryInformations: CountryInformations(
                              id: App.getCountryInfo(_countryCode).id));
                      Navigator.of(context).pushNamed('/Phone2ChangePhone',
                          arguments: User(
                              id: App.user.id,
                              phone: "+" + _countryCode + _phone.text,
                              person: p));
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

  _openSecondPage(phone) async {
    widget._user.phone = phone;
    widget._user.idToken = null;
    if (!widget._user.isExistChecked) {
      User checkUser = User(phone: widget._user.phone);
      Request<bool> request = CheckUserExist(checkUser);
      await request.send(_checkUserExistResponse);
    } else {
      Navigator.of(context)
          .pushNamed('/Phone2', arguments: [widget._user, _isForceRegister]);
    }
  }

  void _checkUserExistResponse(bool userExist, int statusCode, String message) {
    if (statusCode != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      widget._user.isExistChecked = true;
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
