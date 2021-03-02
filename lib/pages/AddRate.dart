import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Person.dart';
import 'package:pickapp/dataObjects/Rate.dart';
import 'package:pickapp/dataObjects/Ride.dart';
import 'package:pickapp/requests/AddRateRequest.dart';
import 'package:pickapp/requests/Request.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class AddRate extends StatefulWidget {
  final Ride _ride;
  final Person _target;

  AddRate(this._ride, this._target);

  @override
  _AddRateState createState() => _AddRateState();
}

class _AddRateState extends State<AddRate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _comment = TextEditingController();
  double _grade = 5;
  int _reason = 0;
  List<String> _reasonsItems;
  bool _isReasonVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reasonsItems = App.getRateReasons(context);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Rate"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              VerticalSpacer(
                height: 50,
              ),
              RatingBar.builder(
                initialRating: 5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: ScreenUtil().setSp(35),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                glow: true,
                unratedColor: Colors.grey.shade300,
                maxRating: 5,
                glowColor: Colors.amber,
                glowRadius: 0.01,
                onRatingUpdate: (rating) {
                  _grade = rating;
                  setState(() {
                    if (rating < 3.5) {
                      _isReasonVisible = true;
                    } else {
                      _isReasonVisible = false;
                    }
                  });
                },
              ),
              VerticalSpacer(
                height: 30,
              ),
              Visibility(
                visible: _isReasonVisible,
                child: ResponsiveWidget.fullWidth(
                  height: 115,
                  child: DifferentSizeResponsiveRow(
                    children: [
                      Expanded(
                        flex: 12,
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: Lang.getString(context, "Reason")),
                          value: _reasonsItems[_reason],
                          onChanged: (String newValue) {
                            setState(() {
                              _reason = _reasonsItems.indexOf(newValue);
                            });
                          },
                          items: _reasonsItems
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
              ),
              ResponsiveWidget.fullWidth(
                height: 128,
                child: DifferentSizeResponsiveRow(
                  children: [
                    Expanded(
                      flex: 12,
                      child: TextFormField(
                        controller: _comment,
                        minLines: 4,
                        maxLines: 20,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(190),
                        ],
                        decoration: InputDecoration(
                          labelText: Lang.getString(context, "Comment"),
                          labelStyle: Styles.labelTextStyle(),
                        ),
                        style: Styles.valueTextStyle(),
                        validator: (value) {
                          String valid, alpha, short;
                          if (_grade < 3) {
                            valid = Validation.validate(value, context);
                            alpha = Validation.isAlphaNumericIgnoreSpaces(
                                context, value);
                            short = Validation.isShort(context, value, 20);
                          }

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
                text_key: "Rate",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    Rate _rate = Rate(
                        comment: _comment.text,
                        grade: _grade,
                        reason: _reason,
                        target: widget._target,
                        ride: widget._ride);
                    Request<bool> request = AddRateRequest(_rate);
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

  _response(bool result, int code, String p3) async {
    if (code != HttpStatus.ok) {
      CustomToast().showErrorToast(p3);
    } else {
      if (result)
        CustomToast()
            .showSuccessToast(Lang.getString(context, "Successfully_added!"));
    }
  }
}
