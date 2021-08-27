import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/ChangePhone.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Spinner.dart';

class Phone2 extends StatefulWidget {
  User user;
  bool isForceRegister = false;
  User oldUser;
  Phone2({this.user, this.isForceRegister, this.oldUser});

  @override
  _Phone2State createState() => _Phone2State();
}

class _Phone2State extends State<Phone2> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _smsCode = TextEditingController();

  bool _isCounterStillOn = true;
  Timer _timer;
  int _timeout = 120;
  String _resendCodeTimer;
  String _resendCodeLocale, _resendCodeInLocale, _secondsLocale;

  auth.UserCredential _userCredential;
  String _verificationSmsId = "";
  String _idToken;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void dispose() {
    _timer.cancel();
    _smsCode.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _resendCodeLocale = Lang.getString(context, "Resend_code");
    _resendCodeInLocale = Lang.getString(context, "Resend_code_in");
    _secondsLocale = Lang.getString(context, "Resend_code_seconds");
    _resendCodeTimer = _resendCodeInLocale + _timeout.toString() + _secondsLocale;

    await _sendCode();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
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
              height: 50,
              child: DifferentSizeResponsiveRow(
                children: [
                  Spacer(
                    flex: 8,
                  ),
                  Expanded(
                    flex: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: Styles.smallIconSize(),
                          ),
                          Text(
                            widget.user == null
                                ? " " + widget.oldUser.phone
                                : " " + widget.user.phone,
                            style: Styles.valueTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 8,
                  ),
                ],
              ),
            ),
            ResponsiveWidget.fullWidth(
              height: 100,
              child: DifferentSizeResponsiveRow(
                children: [
                  Spacer(
                    flex: 11,
                  ),
                  Expanded(
                    flex: 14,
                    child: TextFormField(
                      controller: _smsCode,
                      validator: (value) {
                        String valid = Validation.validate(value, context);
                        if (valid != null) return valid;
                        if (value.length != 6) return Validation.invalid(context);
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      maxLengthEnforced: true,
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Code"),
                        hintText: "024512",
                        labelStyle: Styles.labelTextStyle(),
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 11,
                  ),
                ],
              ),
            ),
            ResponsiveWidget.fullWidth(
              height: 50,
              child: DifferentSizeResponsiveRow(
                children: [
                  Spacer(
                    flex: 6,
                  ),
                  Expanded(
                    flex: 22,
                    child: TextButton(
                      onPressed: !_isCounterStillOn
                          ? () async {
                              await _sendCode();
                              _startTimer();
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.sms_outlined,
                            size: Styles.smallIconSize(),
                          ),
                          Text(
                            " " + _resendCodeTimer,
                            style: Styles.valueTextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(
                    flex: 6,
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
                isRequest: false,
                text_key: "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (widget.user != null)
                      widget.user.verificationCode = _smsCode.text;
                    else if (widget.oldUser != null)
                      widget.oldUser.verificationCode = _smsCode.text;

                    if (_idToken == null)
                      _verifyPhoneSmsCode();
                    else {
                      if (widget.user != null) {
                        _openDetailsPage();
                      } else if (widget.oldUser != null) {
                        _openSpinner();
                        _changePhoneRequest();
                      }
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

  void _startTimer() {
    _timeout = 120;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_timeout == 0) {
          setState(() {
            _resendCodeTimer = _resendCodeLocale;
            _isCounterStillOn = false;
            timer.cancel();
          });
        } else {
          setState(() {
            _timeout--;
            _resendCodeTimer = _resendCodeInLocale + _timeout.toString() + _secondsLocale;
          });
        }
      },
    );
  }

  _sendCode() async {
    _isCounterStillOn = true;
    auth.PhoneVerificationCompleted verificationCompleted =
        (auth.PhoneAuthCredential phoneAuthCredential) async {
      _userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      _idToken = await _userCredential.user.getIdToken();
      if (widget.user != null) {
        _openDetailsPage();
      } else if (widget.oldUser != null) {
        _openSpinner();
        _changePhoneRequest();
      }
    };
    auth.PhoneVerificationFailed verificationFailed = (auth.FirebaseAuthException authException) {
      if (authException.code == "too-many-requests") {
        CustomToast().showErrorToast(Lang.getString(context, "To_many_sms"));
      }
      CustomToast().showErrorToast(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };
    auth.PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      CustomToast().showSuccessToast(Lang.getString(context, "Sms_code_hint"));
      _verificationSmsId = verificationId;
    };

    auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      _verificationSmsId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.user != null ? widget.user.phone : widget.oldUser.phone,
          timeout: Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      CustomToast().showErrorToast("Failed to Verify Phone Number: $e");
    }
  }

  Future<void> _verifyPhoneSmsCode() async {
    _openSpinner();
    try {
      final auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationSmsId,
        smsCode: _smsCode.text,
      );
      final auth.User user = (await _auth.signInWithCredential(credential)).user;
      _idToken = await user.getIdToken();
      if (widget.user != null) {
        Navigator.pop(context);
        _openDetailsPage();
      } else if (widget.oldUser != null) {
        _changePhoneRequest();
      }
    } catch (e) {
      auth.FirebaseAuthException exception = (e as auth.FirebaseAuthException);
      if (exception.code == "session-expired") {
        CustomToast().showErrorToast(Lang.getString(context, "Code_has_expired"));
      } else if (exception.code == "invalid-verification-code") {
        CustomToast().showErrorToast(Lang.getString(context, "Incorrect_verification_code"));
      } else {
        CustomToast().showErrorToast(
            "faild to sign in: code:" + exception.code + " message: " + exception.message);
      }
      Navigator.pop(context);
    }
  }

  _changePhoneResponse(User u, int code, String message) async {
    Navigator.pop(context);
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
    } else {
      User localUser = u;
      localUser.driver = App.driver;
      localUser.person.upcomingRides = App.person.upcomingRides;
      localUser.person.rates = App.person.rates;
      localUser.person.statistics = App.person.statistics;

      App.user = localUser;
      await Cache.setUser(localUser);

      CustomToast().showSuccessToast(Lang.getString(context, "Successfully_edited!"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  _openDetailsPage() {
    widget.user.idToken = _idToken;
    Navigator.pushReplacementNamed(context, "/RegisterDetails",
        arguments: [widget.user, widget.isForceRegister]);
  }

  _changePhoneRequest() {
    widget.oldUser.idToken = _idToken;
    Request<User> request = ChangePhone(widget.oldUser);
    request.send(_changePhoneResponse);
  }

  _openSpinner() {
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
  }
}
