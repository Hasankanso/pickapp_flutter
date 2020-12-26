import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/requests/ForceRegisterPerson.dart';
import 'package:pickapp/requests/RegisterPerson.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class Phone2 extends StatefulWidget {
  User user;
  bool isForceRegister = false;
  Phone2({this.user, this.isForceRegister});

  @override
  _Phone2State createState() => _Phone2State();
}

class _Phone2State extends State<Phone2> {
  String _verificationId = "";
  String _idToken;
  final _formKey = GlobalKey<FormState>();
  bool _isCounterStillOn = true;
  TextEditingController _smsCode = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  Timer _timer;
  int _timeout = 120;
  String _resendCodeTimer;
  String _resendCodeLocale, _resendCodeInLocale, _secondsLocale;
  auth.UserCredential _userCredential;

  void _resendTimer() {
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
            _resendCodeTimer =
                _resendCodeInLocale + _timeout.toString() + _secondsLocale;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    _smsCode.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _resendCodeLocale = Lang.getString(context, "Resend_code");
    _resendCodeInLocale = Lang.getString(context, "Resend_code_in");
    _secondsLocale = Lang.getString(context, "Resend_code_seconds");
    _resendCodeTimer =
        _resendCodeInLocale + _timeout.toString() + _secondsLocale;
    await _sendCode();
    _resendTimer();
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
                            " " + widget.user.phone,
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
                        if (value.length != 6)
                          return Validation.invalid(context);
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
                              _resendTimer();
                              await _sendCode();
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
                text_key: "Register",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    widget.user.verificationCode = _smsCode.text;
                    if (_userCredential == null) {
                      _firebaseVerification();
                    } else {
                      _register(true);
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

  _sendCode() async {
    _isCounterStillOn = true;
    auth.PhoneVerificationCompleted verificationCompleted =
        (auth.PhoneAuthCredential phoneAuthCredential) async {
      _userCredential = await _auth.signInWithCredential(phoneAuthCredential);
      _idToken = await _userCredential.user.getIdToken();
      _register(true);
    };

    auth.PhoneVerificationFailed verificationFailed =
        (auth.FirebaseAuthException authException) {
      if (authException.code == "too-many-requests") {
        CustomToast().showErrorToast(Lang.getString(context, "To_many_sms"));
      }
      CustomToast().showErrorToast(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    auth.PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      CustomToast().showSuccessToast(Lang.getString(context, "Sms_code_hint"));
      _verificationId = verificationId;
    };

    auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("timeout");
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.user.phone,
          timeout: const Duration(seconds: 120),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      CustomToast().showErrorToast("Failed to Verify Phone Number: ${e}");
    }
  }

  Future<void> _firebaseVerification() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Spinner(),
        );
      },
    );
    try {
      final auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCode.text,
      );
      final auth.User user =
          (await _auth.signInWithCredential(credential)).user;
      _idToken = await user.getIdToken();
      _register(false);
    } catch (e) {
      CustomToast().showErrorToast("faild to sign in: " + e);
      Navigator.pop(context);
    }
  }

  _register(bool showSpinner) {
    if (showSpinner == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Spinner(),
          );
        },
      );
    }

    if (!widget.isForceRegister) {
      Request<User> registerRequest = RegisterPerson(widget.user, _idToken);
      registerRequest.send(_registerResponse);
      return;
    } else {
      Request<User> registerRequest =
          ForceRegisterPerson(_idToken, widget.user);
      registerRequest.send(_registerResponse);
      return;
    }
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user = u;
      final userBox = Hive.box("user");
      User cacheUser = u;
      Person cachePerson = u.person;
      cachePerson.rates = null;
      cacheUser.person = cachePerson;
      if (userBox.containsKey(0)) {
        await userBox.put(0, cacheUser);
      } else {
        await userBox.add(cacheUser);
      }

      App.isLoggedIn = true;
      App.isLoggedInNotifier.value = true;
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
