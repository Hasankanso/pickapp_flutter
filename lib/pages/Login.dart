import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: Styles.titleTextStyle(context),
        ),
      ),
      body: Text("Login page"),
    );
  }
}
