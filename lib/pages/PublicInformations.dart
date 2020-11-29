import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class PublicInformation extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Public_Information"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ResponsiveRow(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        minLines: 8,
                        maxLines: 20,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(190),
                        ],
                        decoration: InputDecoration(
                          labelText: "Write your bio",
                          hintText: "hint",
                          labelStyle: Styles.labelTextStyle(),
                          hintStyle: Styles.labelTextStyle(),
                        ),
                        style: Styles.valueTextStyle(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please Write your bio';
                          } else if (value.length < 20) {
                            return 'Your bio is too short';
                          }
                          return null;
                        },
                      ),
                      VerticalSpacer(height: 240),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: ResponsiveWidget(
          width: 270,
          height: 43,
          child: MainButton(
            text_key: "Edit",
            onPressed: () {
              if (_formKey.currentState.validate()) {
                print("Ok");
              }
            },
          ),
        ),
      ),
    );
  }
}
