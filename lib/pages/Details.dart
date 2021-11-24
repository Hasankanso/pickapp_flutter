import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_miles/ads/MainNativeAd.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/User.dart';
import 'package:just_miles/requests/EditAccount.dart';
import 'package:just_miles/requests/ForceRegisterPerson.dart';
import 'package:just_miles/requests/RegisterPerson.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/BirthdayPicker.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:just_miles/utilities/Spinner.dart';

class Details extends StatefulWidget {
  User user;

  Details({this.user});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  BirthdayController _birthday = BirthdayController();
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
    if (widget.user == null) {
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
      _gender = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chattinessItems = App.getChattiness(context);
    _genders = App.getGender(context);
  }

  @override
  Widget build(BuildContext context) {
    Person _newPerson = Person();

    return MainScaffold(
      appBar: MainAppBar(
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
                                flex: 12,
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
                                      _gender = newValue ==
                                              Lang.getString(context, "Male")
                                          ? true
                                          : false;
                                    });
                                  },
                                  items: _genders.map<DropdownMenuItem<String>>(
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
                  Visibility(
                    visible: widget.user != null,
                    child: Column(
                      children: [
                        VerticalSpacer(
                          height: 25,
                        ),
                        ResponsiveWidget.fullWidth(
                          height: 200,
                          child: DifferentSizeResponsiveRow(
                            children: [
                              Spacer(
                                flex: 8,
                              ),
                              Expanded(
                                flex: 60,
                                child: MainNativeAd(),
                              ),
                              Spacer(
                                flex: 8,
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
                      textKey: "Save",
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          Request<Person> request;
                          _newPerson.firstName = _firstName.text;
                          _newPerson.lastName = _lastName.text;
                          _newPerson.birthday = _birthday.chosenDate;
                          _newPerson.gender = _gender;
                          _newPerson.bio = _bioController.text;
                          _newPerson.chattiness = _chattiness;
                          _newPerson.countryInformations =
                              App.person.countryInformations;

                          //await Ads.showRewardedAd(() async {
                          print(App.person.countryInformations);
                          request = EditAccount(_newPerson);
                          await request.send(_response);
                          // });
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
                      textKey: "Next",
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
                              Lang.getString(
                                  context,
                                  App.calculateAge(
                                              widget.user.person.birthday) <
                                          widget.user.person.countryInformations
                                              .drivingAge
                                      ? "Register"
                                      : "Skip"),
                              style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                                fontWeight: FontWeight.w400,
                                color: (!Cache.darkTheme &&
                                        MediaQuery.of(context)
                                                .platformBrightness !=
                                            Brightness.dark)
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
    );
  }

  _response(Person result, int code, String message) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }
    if (App.person.upcomingRides != null) {
      result.upcomingRides = App.person.upcomingRides;
    }
    if (App.person.rates != null) {
      result.rates.addAll(App.person.rates);
    }
    result.statistics = App.user.person.statistics;

    result.countryInformations = App.user.person.countryInformations;

    App.user.person = result;
    User u = App.user;
    await Cache.setUser(u);

    App.updateProfile.value = !App.updateProfile.value;
    CustomToast()
        .showSuccessToast(Lang.getString(context, "Successfully_edited!"));
  }

  Future<void> _register() async {
    if (App.calculateAge(widget.user.person.birthday) <
        widget.user.person.countryInformations.drivingAge) {
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

      await widget.user.person.uploadImage();

      //get device token before registering
      String messagingToken = await FirebaseMessaging.instance.getToken();

      widget.user.person.deviceToken = messagingToken;
      if (widget.user.person.chattiness == null) {
        widget.user.person.chattiness = 1;
      }
      if (!widget.user.isForceRegister) {
        registerRequest = RegisterPerson(widget.user);
      } else {
        registerRequest = ForceRegisterPerson(widget.user);
      }
      registerRequest.send(_registerResponse);
    } else {
      //open become
      Navigator.pushNamed(
        context,
        "/RegisterDriver",
        arguments: [widget.user],
      );
    }
  }

  Future<void> _registerResponse(User u, int code, String message) async {
    if (App.handleErrors(context, code, message)) {
      Navigator.pop(context);
      return;
    }

    App.user = u;
    await Cache.setUser(u);
    App.countriesComponents = null;
    await Cache.setCountriesList(
        [App.person.countryInformations.countryComponent]);
    App.setCountriesComponent(
        [App.person.countryInformations.countryComponent]);
    App.isDriverNotifier.value = false;
    App.user.driver = null;

    App.isLoggedInNotifier.value = true;

    CustomToast().showSuccessToast(Lang.getString(context, "Welcome_Voomcar"));
    // CustomToast().showSuccessToast(
    //     Lang.getString(context, "Email_confirmation_pending"));
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
