import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/dataObjects/CountryInformations.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/utilities/BirthdayPicker.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainImagePicker.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool isPrivacyAndTermsAccepted = false;

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
                    height: 5,
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
                                _gender =
                                    newValue == Lang.getString(context, "Male")
                                        ? true
                                        : false;
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
                            validator: (String value) {
                              String valid =
                                  Validation.validate(value, context);
                              if (valid != null) return valid;
                              String email = Validation.isEmail(context,
                                  value.toLowerCase().replaceAll(' ', ''));
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
                  ResponsiveWidget.fullWidth(
                    height: 80,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 12,
                          child: Row(
                            children: [
                              Checkbox(
                                value: isPrivacyAndTermsAccepted,
                                onChanged: (newValue) {
                                  setState(() {
                                    isPrivacyAndTermsAccepted = newValue;
                                  });
                                },
                              ),
                              Flexible(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                          text: Lang.getString(
                                              context, "I_agree_to_the"),
                                          style: Styles.valueTextStyle()),
                                      WidgetSpan(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () async {
                                            if (await canLaunch(
                                                App.termsAndConditionUrl)) {
                                              await launch(
                                                App.termsAndConditionUrl,
                                                forceSafariVC: false,
                                                forceWebView: false,
                                              );
                                            }
                                          },
                                          child: Text(
                                            Lang.getString(
                                                context, "Terms_&_Conditions"),
                                            style: Styles.valueTextStyle(
                                                bold: FontWeight.bold,
                                                color: Styles.primaryColor()),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              ' ${Lang.getString(context, "and")} ',
                                          style: Styles.valueTextStyle()),
                                      WidgetSpan(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed("/PrivacyPolicy");
                                          },
                                          child: Text(
                                            Lang.getString(
                                                context, "Privacy_Policy"),
                                            style: Styles.valueTextStyle(
                                                bold: FontWeight.bold,
                                                color: Styles.primaryColor()),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                          text: '.',
                                          style: Styles.valueTextStyle()),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                textKey: "Next",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (_birthday.chosenDate == null) {
                      CustomToast().showErrorToast(
                          Lang.getString(context, "Pick_birthday"));
                      return;
                    }
                    if (!isPrivacyAndTermsAccepted) {
                      CustomToast().showErrorToast(
                          "${Lang.getString(context, "Please_agree_to_the")} ${Lang.getString(context, "Terms_&_Conditions")} ${Lang.getString(context, "and")} ${Lang.getString(context, "Privacy_Policy")}");
                      return;
                    }
                    CountryInformations cI =
                        App.countriesInformations[_country];
                    Person _newPerson = Person();
                    _newPerson.firstName = _firstName.text;
                    _newPerson.lastName = _lastName.text;
                    _newPerson.birthday = _birthday.chosenDate;
                    _newPerson.countryInformations = cI;
                    _newPerson.gender = _gender;
                    if (_imageController.pickedImage != null) {
                      _newPerson.profilePictureUrl =
                          _imageController.pickedImage.path;
                    }
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
