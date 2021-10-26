import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/LoginRequest.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/requests/VerifyAccount.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Spinner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _codeFormKey = GlobalKey<FormState>();
  String _text = "";

  TextEditingController _phone = TextEditingController();
  List<String> _countriesCodes = App.countriesInformationsCodes;
  var _countryCode = "961";
  User _user;
  TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            VerticalSpacer(
              height: 20,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: ScreenUtil().setSp(70),
                backgroundImage: AssetImage("lib/images/logo.png"),
              ),
            ),
            Form(
              key: _phoneFormKey,
              child: ResponsiveWidget.fullWidth(
                height: 170,
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
                          LengthLimitingTextInputFormatter(
                              App.getCountryInfo(_countryCode).digits),
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
            ),
            ResponsiveWidget.fullWidth(
              height: 120,
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
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 130,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Login",
                isRequest: true,
                onPressed: () async {
                  if (_phoneFormKey.currentState.validate()) {
                    Request<String> request =
                        VerifyAccount("+" + _countryCode + _phone.text);
                    await request.send(_respondAccountVerification);
                  }
                },
              ),
            ),
            ResponsiveWidget.fullWidth(
              height: 60,
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
                          Lang.getString(context, "New_to_Voomcar?") + " ",
                          style: Styles.labelTextStyle(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/Register');
                          },
                          child: Text(
                            Lang.getString(context, "Register"),
                            style: Styles.valueTextStyle(
                                color: Styles.primaryColor(), underline: true),
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

  _respondAccountVerification(String p1, int code, String message) {
    if (App.handleErrors(context, code, message)) {
      return;
    }

    _user = User(phone: "+" + _countryCode + _phone.text);
    codePopUp(context, p1);
  }

  codePopUp(BuildContext context, String title) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black45,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: Styles.labelTextStyle(),
      descStyle: Styles.valueTextStyle(),
      animationDuration: Duration(milliseconds: 400),
    );
    Alert(
        context: context,
        style: alertStyle,
        title: Lang.getString(context, "Verification_is_sent"),
        desc: title,
        content: Form(
          key: _codeFormKey,
          child: Row(
            children: [
              Spacer(
                flex: 5,
              ),
              Expanded(
                flex: 10,
                child: TextFormField(
                  controller: _code,
                  validator: (value) {
                    String valid = Validation.validate(value, context);
                    if (valid != null) return valid;
                    if (value.length != 5) return Validation.invalid(context);
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                  maxLengthEnforced: true,
                  decoration: InputDecoration(
                    labelText: Lang.getString(context, "Code"),
                    hintText: "02451",
                    labelStyle: Styles.labelTextStyle(),
                  ),
                  onFieldSubmitted: (String text) {},
                ),
              ),
              Spacer(
                flex: 5,
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            child: Text(Lang.getString(context, "Verify"),
                style: Styles.buttonTextStyle(),
                overflow: TextOverflow.visible),
            color: Styles.primaryColor(),
            onPressed: () {
              if (_codeFormKey.currentState.validate()) {
                _user.verificationCode = _code.text;
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return WillPopScope(
                      onWillPop: () async => false,
                      child: Center(
                        child: Spinner(),
                      ),
                    );
                  },
                );

                Request<User> request;
                FirebaseMessaging.instance.getToken().then((token) => {
                      request = LoginRequest(_user, token),
                      request.send((u, code, message) =>
                          codeValidationResponse(u, code, message, context)),
                    });
              }
            },
          ),
        ]).show();
  }

  Future<void> codeValidationResponse(
      User u, int code, String message, context) async {
    if (App.handleErrors(context, code, message)) {
      Navigator.pop(context);
      return;
    }

    App.user = u;
    await Cache.setRates(u.person.rates);
    await Cache.setUser(u);

    App.countriesComponents = null;
    await Cache.setCountriesList(
        [App.person.countryInformations.countryComponent]);
    App.setCountriesComponent(
        [App.person.countryInformations.countryComponent]);

    if (App.user.driver != null) App.isDriverNotifier.value = true;
    App.isLoggedInNotifier.value = true;

    CustomToast()
        .showSuccessToast(Lang.getString(context, "Welcome_back_Voomcar"));
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
