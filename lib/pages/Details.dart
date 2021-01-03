import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Driver.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/pages/Inbox.dart';
import 'package:pickapp/requests/ForceRegisterPerson.dart';
import 'package:pickapp/requests/RegisterPerson.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/BirthdayPicker.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:pickapp/utilities/Spinner.dart';

class Details extends StatefulWidget {
  bool isForceRegister;
  User user;
  String idToken;
  Details({this.isForceRegister, this.user, this.idToken});
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  BirthdayController _birthday = BirthdayController();
  String _country;
  List<String> _countries;
  int _chattiness;
  List<String> _chattinessItems;
  List<String> _genders;
  bool _gender;
  DateTime _birthdayInit;

  @override
  void dispose() {
    // TODO: implement dispose
    _bioController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _countries = App.countriesInformationsNames;
    if (widget.user == null) {
      _country = App.person.countryInformations.name;
      _chattiness = App.person.chattiness;
      _gender = App.person.gender;
      _birthdayInit = App.person.birthday;
      if (!Validation.isNullOrEmpty(App.person.bio)) {
        _bioController.text = App.person.bio;
      }
      _firstName.text = App.person.firstName;
      _lastName.text = App.person.lastName;
    } else {
      _chattiness = 1;

      //these values doesn't affect anything, we stored it just to prevent country dropdown from error
      _country = "لبنان";
      _gender = false;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _chattinessItems = <String>[
      Lang.getString(context, "I'm_a_quiet_person"),
      Lang.getString(context, "I_talk_depending_on_my_mood"),
      Lang.getString(context, "I_love_to_chat!"),
    ];
    _genders = <String>[
      Lang.getString(context, "Male"),
      Lang.getString(context, "Female"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.user == null,
      child: MainScaffold(
        appBar: MainAppBar(
          hideBackBtn: widget.user != null,
          title: Lang.getString(context, "Details"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: widget.user == null,
                      child: Column(
                        children: [
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
                                      labelText:
                                          Lang.getString(context, "First_Name"),
                                      hintText:
                                          Lang.getString(context, "Name_hint"),
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
                                      labelText:
                                          Lang.getString(context, "Last_Name"),
                                      hintText: Lang.getString(
                                          context, "Last_name_hint"),
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
                                      labelText:
                                          Lang.getString(context, "Country"),
                                    ),
                                    isExpanded: true,
                                    value: '$_country',
                                    validator: (val) {
                                      String valid =
                                          Validation.validate(val, context);
                                      if (valid != null) return valid;
                                      return null;
                                    },
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _country = newValue;
                                      });
                                    },
                                    items: _countries
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                                      labelText:
                                          Lang.getString(context, "Gender"),
                                    ),
                                    isExpanded: true,
                                    value: _gender ? _genders[0] : _genders[1],
                                    validator: (val) {
                                      String valid =
                                          Validation.validate(val, context);
                                      if (valid != null) return valid;
                                      return null;
                                    },
                                    onChanged: (String newValue) {
                                      setState(() {
                                        _gender =
                                            newValue == "Male" ? true : false;
                                      });
                                    },
                                    items: _genders
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
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
                        ],
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 115,
                      child: DifferentSizeResponsiveRow(
                        children: [
                          Expanded(
                            flex: 12,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                  labelText:
                                      Lang.getString(context, "Chattiness")),
                              value: _chattinessItems[_chattiness],
                              onChanged: (String newValue) {
                                setState(() {
                                  _chattiness =
                                      _chattinessItems.indexOf(newValue);
                                });
                              },
                              items: _chattinessItems
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                    Visibility(
                      visible: widget.user == null,
                      child: ResponsiveWidget.fullWidth(
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
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 128,
                      child: DifferentSizeResponsiveRow(
                        children: [
                          Expanded(
                            flex: 12,
                            child: TextFormField(
                              controller: _bioController,
                              minLines: 4,
                              textInputAction: TextInputAction.done,
                              maxLines: 20,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(190),
                              ],
                              decoration: InputDecoration(
                                labelText: Lang.getString(context, "Bio"),
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
                                    Validation.isAlphaNumericIgnoreSpaces(
                                        context, value);
                                String short =
                                    Validation.isShort(context, value, 20);

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
        bottomNavigationBar: widget.user == null
            ? ResponsiveWidget.fullWidth(
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
                            /*
                            CountryInformations cI =
                                App.countriesInformations[_country];
                            Person _newPerson = Person();
                            _newPerson.firstName = _firstName.text;
                            _newPerson.lastName = _lastName.text;
                            _newPerson.birthday = _birthday.chosenDate;
                            _newPerson.countryInformations = cI;
                            _newPerson.gender = _gender;
                            _newPerson.bio = _bioController.text;
                            _newPerson.chattiness = _chattiness;
                            Request<Person> request = EditAccount(_newPerson);
                            await request.send(_response);*/
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            : ResponsiveWidget.fullWidth(
                height: 110,
                child: Column(
                  children: [
                    ResponsiveWidget(
                      width: 270,
                      height: 50,
                      child: MainButton(
                        isRequest: false,
                        text_key: "Register",
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.user.person.bio = _bioController.text;
                            widget.user.person.chattiness = _chattiness;
                            _register();
                          }
                        },
                      ),
                    ),
                    ResponsiveWidget.fullWidth(
                      height: 50,
                      child: DifferentSizeResponsiveRow(
                        children: <Widget>[
                          Spacer(
                            flex: 2,
                          ),
                          Expanded(
                            flex: 11,
                            child: TextButton(
                              onPressed: () {
                                _register();
                              },
                              child: Text(
                                Lang.getString(context, "Skip"),
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(15),
                                  fontWeight: FontWeight.w400,
                                  color: !Cache.darkTheme
                                      ? Styles.valueColor()
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  _response(Person result, int code, String p3) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(p3);
    } else {
      List<Ride> upcomingRides = App.person.upcomingRides;
      List<Rate> rates = App.person.rates;

      final userBox = Hive.box("user");
      User cacheUser = App.user;
      Person cachePerson = result;
      cachePerson.rates = null;
      cachePerson.upcomingRides = upcomingRides;

      if (App.user.driver != null) {
        cacheUser.driver = Driver(
            id: App.user.driver.id,
            cars: App.user.driver.cars,
            updated: App.user.driver.updated);
      }

      cacheUser.person = cachePerson;

      await userBox.put(0, cacheUser);

      result.upcomingRides = upcomingRides;
      result.rates = rates;
      App.user.person = result;
      App.isLoggedInNotifier.notifyListeners();

      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
    }
  }

  _register() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Spinner(),
          ),
        );
      },
    );

    Request<User> registerRequest;
    if (!widget.isForceRegister) {
      registerRequest = RegisterPerson(widget.user, widget.idToken);
    } else {
      registerRequest = ForceRegisterPerson(widget.idToken, widget.user);
    }
    registerRequest.send(_registerResponse);
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(message);
      Navigator.pop(context);
    } else {
      App.user = u;
      final userBox = Hive.box("user");
      User cacheUser = u;
      Person cachePerson = u.person;
      cachePerson.rates = null;
      cacheUser.person = cachePerson;
      if (userBox.containsKey(0)) {
        await userBox.put(0, cacheUser);
      } else {
        await userBox.add(cacheUser);
      }

      App.isLoggedIn = true;
      App.isLoggedInNotifier.value = true;
      Inbox.subscribeToChannel();
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Welcome_PickApp"));
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }
}
