import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/BirthdayPicker.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  User _newUser = User();
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  BirthdayController _birthday = BirthdayController();
  String _country = App.countriesInformationsNames[1];
  List<String> _countries = App.countriesInformationsNames;
  List<String> _genders;
  bool _gender = true;
  DateTime _birthdayInit;
  MainImageController _imageController = MainImageController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _genders = <String>[
      Lang.getString(context, "Male"),
      Lang.getString(context, "Female"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Register"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  VerticalSpacer(
                    height: 20,
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 100,
                    child: Align(
                      alignment: Alignment.center,
                      child: MainImagePicker(
                        controller: _imageController,
                        title: Lang.getString(context, "Me"),
                      ),
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 100,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            controller: _firstName,
                            minLines: 1,
                            textInputAction: TextInputAction.next,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15),
                            ],
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "First_Name"),
                              hintText: Lang.getString(context, "Name_hint"),
                              labelStyle: Styles.labelTextStyle(),
                              hintStyle: Styles.labelTextStyle(),
                            ),
                            style: Styles.valueTextStyle(),
                            validator: (value) {
                              String valid =
                                  Validation.validate(value, context);
                              String alpha =
                                  Validation.isAlphabeticIgnoreSpaces(
                                      context, value);

                              if (valid != null)
                                return valid;
                              else if (alpha != null) return alpha;
                              return null;
                            },
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            controller: _lastName,
                            minLines: 1,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(15),
                            ],
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "Last_Name"),
                              hintText:
                                  Lang.getString(context, "Last_name_hint"),
                              labelStyle: Styles.labelTextStyle(),
                              hintStyle: Styles.labelTextStyle(),
                            ),
                            style: Styles.valueTextStyle(),
                            validator: (value) {
                              String valid =
                                  Validation.validate(value, context);
                              String alpha =
                                  Validation.isAlphabeticIgnoreSpaces(
                                      context, value);
                              if (valid != null)
                                return valid;
                              else if (alpha != null)
                                return alpha;
                              else
                                return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 115,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "Country"),
                            ),
                            isExpanded: true,
                            value: '$_country',
                            validator: (val) {
                              String valid = Validation.validate(val, context);
                              if (valid != null) return valid;
                              return null;
                            },
                            onChanged: (String newValue) {
                              setState(() {
                                _country = newValue;
                              });
                            },
                            items: _countries
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "Gender"),
                            ),
                            isExpanded: true,
                            value: _gender ? _genders[0] : _genders[1],
                            validator: (val) {
                              String valid = Validation.validate(val, context);
                              if (valid != null) return valid;
                              return null;
                            },
                            onChanged: (String newValue) {
                              setState(() {
                                _gender = newValue == "Male" ? true : false;
                              });
                            },
                            items: _genders
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 100,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: _email,
                            minLines: 1,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "Email"),
                              hintText: Lang.getString(context, "Email_hint"),
                              labelStyle: Styles.labelTextStyle(),
                              hintStyle: Styles.labelTextStyle(),
                            ),
                            style: Styles.valueTextStyle(),
                            validator: (value) {
                              String valid =
                                  Validation.validate(value, context);
                              String email = Validation.isEmail(context, value);
                              if (valid != null) return valid;
                              if (email != null) return email;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 80,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 12,
                          child: BirthDayPicker(
                            _birthday,
                            startDate: _birthdayInit,
                          ),
                        )
                      ],
                    ),
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
                    CountryInformations cI =
                        App.countriesInformations[_country];
                    Person _newPerson = Person();
                    _newPerson.firstName = _firstName.text;
                    _newPerson.lastName = _lastName.text;
                    _newPerson.birthday = _birthday.chosenDate;
                    _newPerson.countryInformations = cI;
                    _newPerson.gender = _gender;
                    await _newPerson.setImage(_imageController.pickedImage);

                    _newUser.person = _newPerson;
                    _newUser.email = _email.text;
                    Navigator.pushNamed(context, "/Phone", arguments: _newUser);
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
