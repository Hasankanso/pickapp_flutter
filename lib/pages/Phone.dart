import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Phone extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phone = TextEditingController();
  TextEditingController _code = TextEditingController();

  User _user;
  Phone(this._user);

  @override
  Widget build(BuildContext context) {
    _code.text = _user.person.countryInformations.code;
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
                            _user.person.countryInformations.digits),
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
                isRequest: false,
                text_key: "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _user.phone = _phone.text;
                    //Navigator.pushNamed(context, "/Phone", arguments: _newUser);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
