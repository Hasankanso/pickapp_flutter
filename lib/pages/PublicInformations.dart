import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class PublicInformation extends StatefulWidget {
  @override
  _PublicInformationState createState() => _PublicInformationState();
}

class _PublicInformationState extends State<PublicInformation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'I talk depending on my mood';
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Public_Information"),
      ),
      body: Column(
        children: [
          ResponsiveRow(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    VerticalSpacer(
                      height: 20,
                    ),
                    Text(
                      "Chattiness",
                      style: Styles.labelTextStyle(),
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      underline: Container(
                        height: 1,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        "I'm the quiet person",
                        "I talk depending on my mood",
                        "I love to chat!",
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      minLines: 4,
                      textInputAction: TextInputAction.done,
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
                  ],
                ),
              ),
            ],
          ),
        ],
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
