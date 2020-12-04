import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/dataObjects/CountryInformations.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/EditAccount.dart';
import 'package:pickapp/requests/GetCountries.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/DateTimePicker.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainImagePicker.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  List<bool> _genders;
  bool _gender = App.person.gender;
  DateTimeController _birthday = DateTimeController();
  String _country = App.person.countryInformations.name;
  List<String> _countries = [App.person.countryInformations.name];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstName.text = App.person.firstName;
    _lastName.text = App.person.lastName;
    if (App.person.gender == true)
      _genders = [true, false];
    else
      _genders = [false, true];
    if (App.countriesInformationsNames == null ||
        App.countriesInformationsNames.isEmpty) {
      Request<List<CountryInformations>> request = GetCountries();
      request.send(_getCountriesResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Account"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ResponsiveWidget.fullWidth(
                    height: 130,
                    child: Center(
                      child: MainImagePicker(),
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
                              LengthLimitingTextInputFormatter(190),
                            ],
                            decoration: InputDecoration(
                              labelText: Lang.getString(context, "First_Name"),
                              hintText:
                                  Lang.getString(context, "Write_your_bio"),
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
                                  Lang.getString(context, "Write_your_bio"),
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
                    height: 100,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 5,
                          child: DropdownButtonFormField<String>(
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
                          child: ToggleButtons(
                            selectedColor: Styles.primaryColor(),
                            color: Styles.labelColor(),
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            textStyle: Styles.valueTextStyle(),
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(" " + "Male" + " "),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text("Female"),
                              ),
                            ],
                            onPressed: (int index) {
                              if (index == 0) {
                                _genders = [true, false];
                                _gender = true;
                              } else {
                                _genders = [false, true];
                                _gender = false;
                              }
                              setState(() {});
                            },
                            isSelected: _genders,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 20,
                    child: DifferentSizeResponsiveRow(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Birthday",
                            style: Styles.labelTextStyle(),
                          ),
                        ),
                        Spacer(
                          flex: 6,
                        )
                      ],
                    ),
                  ),
                  ResponsiveWidget.fullWidth(
                    height: 80,
                    child: ResponsiveRow(
                      children: [
                        DateTimePicker(
                          true,
                          _birthday,
                          startDate: App.person.birthday,
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
                text_key: "Edit",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    CountryInformations cI =
                        App.countriesInformations[_country];
                    Person _newPerson = App.person;
                    _newPerson.firstName = _firstName.text;
                    _newPerson.lastName = _lastName.text;
                    _newPerson.birthday = _birthday.chosenDate;
                    _newPerson.countryInformations = cI;
                    _newPerson.gender = _gender;
                    Request<Person> request = EditAccount(_newPerson);
                    request.send(response);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getCountriesResponse(List<CountryInformations> result, int code, String p3) {
    if (code != HttpStatus.ok) {
      //todo toast
    } else {
      App.countriesInformationsNames = List<String>();
      App.countriesInformations = Map<String, CountryInformations>();
      for (CountryInformations c in result) {
        App.countriesInformations[c.name] = c;
        App.countriesInformationsNames.add(c.name);
      }
      _countries = App.countriesInformationsNames;
      setState(() {});
    }
  }

  response(Person result, int code, String p3) {
    if (code != HttpStatus.ok) {
      //todo toast
    } else {
      List<Ride> upcomingRides = App.person.upcomingRides;
      List<Rate> rates = App.person.rates;
      result.upcomingRides = upcomingRides;
      result.rates = rates;
      App.user.person = result;
      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
    }
  }
}
