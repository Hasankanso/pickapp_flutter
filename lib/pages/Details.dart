import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Validation.isNullOrEmpty(App.person.bio)) {
      _bioController.text = App.person.bio;
    }
    Future.delayed(Duration.zero, () {
      Lang.getString(context, "Write_your_bio");
    });
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = App.person.chattiness;
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Details"),
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
                      Lang.getString(context, "Chattiness"),
                      style: Styles.labelTextStyle(),
                    ),
                    DropdownButtonFormField<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'field required' : null,
                      items: <String>[
                        Lang.getString(context, "I'm_a_quiet_person"),
                        Lang.getString(context, "I_talk_depending_on_my_mood"),
                        Lang.getString(context, "I_love_to_chat!"),
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    TextFormField(
                      controller: _bioController,
                      minLines: 4,
                      textInputAction: TextInputAction.done,
                      maxLines: 20,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(190),
                      ],
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Bio"),
                        hintText: Lang.getString(context, "Write_your_bio"),
                        labelStyle: Styles.labelTextStyle(),
                        hintStyle: Styles.labelTextStyle(),
                      ),
                      style: Styles.valueTextStyle(),
                      validator: (value) {
                        return Validation.validate(value, context,
                            empty: true,
                            short: true,
                            length: 20,
                            alphabeticIgnoreSpaces: true);
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
                print(1);
              }
            },
          ),
        ),
      ),
    );
  }
}
