import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/Driver.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isForceRegister = false;
  bool _codeSent = false;
  TextEditingController _smsCode = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    await _sendCode();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: "Phone",
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
                    flex: 34,
                    child: Text(
                        Lang.getString(context, "Verification_is_sent") +
                            "\n" +
                            widget.user.phone),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
            ResponsiveWidget.fullWidth(
              height: 100,
              child: DifferentSizeResponsiveRow(
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Expanded(
                    flex: 34,
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
                isRequest: false,
                text_key: "Verify",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    widget.user.verificationCode = _smsCode.text;
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return Center(
                          child: Spinner(),
                        );
                      },
                    );
                    FirebaseVerification();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendCode() async {
    auth.PhoneVerificationCompleted verificationCompleted =
        (auth.PhoneAuthCredential phoneAuthCredential) async {
      _codeSent = false;
      await _auth.signInWithCredential(phoneAuthCredential);
      CustomToast().showSuccessToast(
          "Phone number automatically verified and user signed in: ${phoneAuthCredential}");
    };

    auth.PhoneVerificationFailed verificationFailed =
        (auth.FirebaseAuthException authException) {
      _codeSent = false;
      CustomToast().showErrorToast(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    auth.PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _codeSent = true;
      CustomToast()
          .showSuccessToast('Please enter your phone verification code.');
      _verificationId = verificationId;
    };

    auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      print("timeout");
      _codeSent = false;
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: widget.user.phone,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      _codeSent = false;
      CustomToast().showErrorToast("Failed to Verify Phone Number: ${e}");
    }
  }

  Future<void> FirebaseVerification() async {
    try {
      final auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsCode.text,
      );
      final auth.User user =
          (await _auth.signInWithCredential(credential)).user;

      if (!widget.isForceRegister) {
        Request<User> registerRequest = RegisterPerson(widget.user, user.uid);
        registerRequest.send(response);
        return;
      } else {
        Request<User> registerRequest =
            ForceRegisterPerson(user.uid, widget.user);
        registerRequest.send(response);
        return;
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
      CustomToast().showErrorToast("Failed to sign in");
    }
  }

  Future<void> response(User u, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user = u;
      final userBox = Hive.box("user");
      User cacheUser = u;
      Person cachePerson = u.person;
      cachePerson.rates = null;
      var regions = u.driver.regions;
      if (u.driver != null) {
        var d = u.driver;
        cacheUser.driver = Driver(id: d.id, cars: d.cars, updated: d.updated);
      }
      cacheUser.person = cachePerson;
      if (!userBox.containsKey(0)) {
        await userBox.put(0, cacheUser);
      } else {
        userBox.add(cacheUser);
      }
      await Hive.openBox('regions');
      final regionsBox = Hive.box("regions");

      if (regionsBox.containsKey(0)) {
        await regionsBox.put(0, regions);
      } else {
        regionsBox.add(regions);
      }
      regionsBox.close();

      App.isLoggedIn = true;
      App.isLoggedInNotifier.value = true;
      App.isDriverNotifier.value = true;
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
