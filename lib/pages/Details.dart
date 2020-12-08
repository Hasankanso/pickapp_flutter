import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
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
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/DateTimePicker.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  List<bool> _genders;
  bool _gender = App.person.gender;
  DateTimeController _birthday = DateTimeController();
  String _country = App.person.countryInformations.name;
  List<String> _countries = [App.person.countryInformations.name];
  int _chattiness = App.person.chattiness;
  List<String> _chattinessItems;

  String formattedDate = "Change";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!Validation.isNullOrEmpty(App.person.bio)) {
      _bioController.text = App.person.bio;
    }
    _firstName.text = App.person.firstName;
    _lastName.text = App.person.lastName;
    if (App.person.gender == true)
      _genders = [true, false];
    else
      _genders = [false, true];
    if (App.countriesInformationsNames == null ||
        App.countriesInformationsNames.isEmpty) {
      Future.delayed(Duration.zero, () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      });
      Request<List<CountryInformations>> request = GetCountries();
      request.send(_getCountriesResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    _setDate(date) {
      setState(() {
        final DateFormat formatter = DateFormat('yyyy-MM-dd');
        final String formatted = formatter.format(date);
        formattedDate = formatted;
      });
    }

    _chattinessItems = <String>[
      Lang.getString(context, "I'm_a_quiet_person"),
      Lang.getString(context, "I_talk_depending_on_my_mood"),
      Lang.getString(context, "I_love_to_chat!"),
    ];
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Details"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                            hintText: Lang.getString(context, "Write_your_bio"),
                            labelStyle: Styles.labelTextStyle(),
                            hintStyle: Styles.labelTextStyle(),
                          ),
                          style: Styles.valueTextStyle(),
                          validator: (value) {
                            String valid = Validation.validate(value, context);
                            String alpha = Validation.isAlphabeticIgnoreSpaces(
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
                            hintText: Lang.getString(context, "Write_your_bio"),
                            labelStyle: Styles.labelTextStyle(),
                            hintStyle: Styles.labelTextStyle(),
                          ),
                          style: Styles.valueTextStyle(),
                          validator: (value) {
                            String valid = Validation.validate(value, context);
                            String alpha = Validation.isAlphabeticIgnoreSpaces(
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
                            labelText: "Gender",
                          ),
                          isExpanded: true,
                          value: 'Male',
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
                          items: ["Male", "Female"]
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
                      Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 20,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: Lang.getString(context, "Chattiness")),
                          value: _chattinessItems[App.person.chattiness],
                          onChanged: (String newValue) {
                            setState(() {
                              _chattiness = _chattinessItems.indexOf(newValue);
                            });
                          },
                          items: _chattinessItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
                ResponsiveWidget.fullWidth(
                  height: 80,
                  child: ResponsiveRow(
                    children: [
                      Text(
                        "Birthday",
                        style: Styles.labelTextStyle(),
                      ),
                      TextButton(
                        child: Text(
                          formattedDate.toString(),
                          style: Styles.valueTextStyle(),
                        ),
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            onConfirm: (date) {
                              _setDate(date);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                ResponsiveWidget.fullWidth(
                  height: 128,
                  child: ResponsiveRow(
                    children: [
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
                          String valid = Validation.validate(value, context);
                          String alpha = Validation.isAlphabeticIgnoreSpaces(
                              context, value);
                          String short = Validation.isShort(context, value, 20);

                          if (valid != null)
                            return valid;
                          else if (alpha != null)
                            return alpha;
                          else if (short != null)
                            return short;
                          else
                            return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                isRequest: true,
                text_key: "Save",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    CountryInformations cI =
                        App.countriesInformations[_country];
                    Person _newPerson = App.person;
                    _newPerson.firstName = _firstName.text;
                    _newPerson.lastName = _lastName.text;
                    _newPerson.birthday = _birthday.chosenDate;
                    _newPerson.countryInformations = cI;
                    _newPerson.gender = _gender;
                    _newPerson.bio = _bioController.text;
                    _newPerson.chattiness = _chattiness;
                    Request<Person> request = EditAccount(_newPerson);
                    await request.send(_response);
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
    Navigator.pop(context);
  }

  _response(Person result, int code, String p3) {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(p3);
    } else {
      List<Ride> upcomingRides = App.person.upcomingRides;
      List<Rate> rates = App.person.rates;
      result.upcomingRides = upcomingRides;
      result.rates = rates;
      App.user.person = result;
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }
}
