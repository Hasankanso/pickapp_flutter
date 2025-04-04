import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/CountryInformations.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/CheckUserExist.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/PopUp.dart';
import 'package:just_miles/utilities/Responsive.dart';

class Phone extends StatefulWidget {
  User _user;

  Phone(this._user);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phone = TextEditingController();
  TextEditingController _code = TextEditingController();
  List<String> _countriesCodes = App.countriesInformationsCodes;
  var _countryCode = "961";
  CountryInformations _countryInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget._user != null && widget._user.phone != null) {
      try {
        _phone.text = (widget._user.phone)
            .split("+" + widget._user.person.countryInformations.code)[1];
      } catch (e) {
        _phone.text = "";
      }
    }
    _countryInfo = App.getCountryInfo(_countryCode);
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VerticalSpacer(
                height: 150,
              ),
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
                                _countryInfo = App.getCountryInfo(_countryCode);
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
                              : _countryInfo.digits),
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
              VerticalSpacer(
                height: 20,
              ),
              ResponsiveWidget.fullWidth(
                height: 200,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Spacer(
                      flex: 8,
                    ),
                    Expanded(
                      flex: 60,
                      child: MainNativeAd(),
                    ),
                    Spacer(
                      flex: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                textKey: "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (widget._user != null) {
                      String phone = "+" + _code.text + _phone.text;
                      if (widget._user.phone != phone) {
                        widget._user.isExistChecked = false;
                        await _openSecondPage(phone);
                      } else if (widget._user.idToken != null) {
                        Navigator.of(context).pushNamed('/RegisterDetails',
                            arguments: [widget._user]);
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
                          countryInformations:
                              CountryInformations(id: _countryInfo.id));
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
      Navigator.of(context).pushNamed('/Phone2', arguments: [widget._user]);
    }
  }

  void _checkUserExistResponse(bool userExist, int statusCode, String message) {
    if (App.handleErrors(context, statusCode, message)) {
      return;
    }

    widget._user.isExistChecked = true;
    if (userExist == true) {
      widget._user.isForceRegister = true;
      PopUp.areYouSure(
        Lang.getString(context, "Ignore"),
        Lang.getString(context, "Login"),
        Lang.getString(context, "Account_with_phone") +
            _code.text +
            _phone.text +
            Lang.getString(context, "Exist_desc"),
        Lang.getString(context, "Account_already_exist"),
        Styles.primaryColor(),
        (bool) => bool ? _skip() : _login(),
        highlightYes: false,
        hideClose: true,
      ).confirmationPopup(context);
    } else {
      widget._user.isForceRegister = false;
      Navigator.of(context).pushNamed('/Phone2', arguments: [widget._user]);
    }
  }

  _login() {
    Navigator.of(context).pushNamed('/Login');
  }

  _skip() {
    Navigator.of(context).pushNamed('/Phone2', arguments: [widget._user]);
  }
}
