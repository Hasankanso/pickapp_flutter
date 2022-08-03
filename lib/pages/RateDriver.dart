import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:just_miles/classes/Appache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/pages/PersonView.dart';
import 'package:just_miles/repository/notification/notification_repository.dart';
import 'package:just_miles/requests/RateDriverRequest.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/RateStars.dart';
import 'package:just_miles/utilities/Responsive.dart';

class RateDriver extends StatefulWidget {
  final Ride _ride;
  final Person _target;
  final String _reason;
  final DateTime _cancellationDate;
  final MainNotification _notification;

  RateDriver(this._ride, this._target, this._reason, this._cancellationDate,
      this._notification);

  @override
  _RateDriverState createState() => _RateDriverState();
}

class _RateDriverState extends State<RateDriver> {
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
              Card(
                elevation: 3.0,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            settings: RouteSettings(name: "/UserView"),
                            builder: (context) => MainScaffold(
                                  appBar: MainAppBar(
                                    title: Lang.getString(context, "Profile"),
                                  ),
                                  body: PersonView(
                                    person: widget._target,
                                  ),
                                )));
                  },
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: Styles.largeIconSize(),
                    color: Styles.lightLabelColor(),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 28,
                    backgroundImage: widget._target.networkImage,
                  ),
                  title: Padding(
                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Spacer(
                              flex: 1,
                            ),
                            Flexible(
                              flex: 80,
                              child: Text(
                                widget._target.firstName +
                                    " " +
                                    widget._target.lastName +
                                    ", " +
                                    App.calculateAge(widget._target.birthday)
                                        .toString(),
                                style: Styles.headerTextStyle(),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                    child: Column(
                      children: [
                        RateStars(
                          widget._target.statistics.rateAverage,
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              VerticalSpacer(
                height: 20,
              ),
              if (widget._reason != null)
                Column(
                  children: [
                    Text(
                      Lang.getString(context, "Cancellation_reason:"),
                      style: Styles.labelTextStyle(),
                    ),
                    VerticalSpacer(
                      height: 10,
                    ),
                    Text(
                      widget._reason,
                      textAlign: TextAlign.center,
                      style: Styles.valueTextStyle(),
                    ),
                  ],
                ),
              VerticalSpacer(
                height: 20,
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
                  color: Colors.yellow,
                ),
                glow: true,
                unratedColor: Colors.grey.shade300,
                maxRating: 5,
                glowColor: Colors.yellow,
                glowRadius: 0.01,
                onRatingUpdate: (rating) {
                  _grade = rating;
                  setState(() {
                    if (rating <= Rate.maximumRateReasonRequired) {
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
                          String valid, short;
                          if (_grade < Rate.maximumRateReasonRequired) {
                            valid = Validation.validate(value, context);
                            short = Validation.isShort(context, value, 5);
                          }

                          if (_grade <= 4 && valid != null)
                            return valid;
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
                textKey: "Rate",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (widget._cancellationDate != null &&
                        widget._cancellationDate.compareTo(DateTime.now()
                                .add(App.availableDurationToRate)) >=
                            0) {
                      return CustomToast().showErrorToast(
                          Lang.getString(context, "Rate_days_validation"));
                    }
                    if (_grade >= 3) {
                      _reason = null;
                    }
                    Rate _rate = Rate(
                        comment: _comment.text,
                        grade: _grade,
                        reason: _reason,
                        target: widget._target,
                        ride: widget._ride);
                    Request<bool> request = RateDriverRequest(_rate);
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

  _response(bool result, int code, String message) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }

    if (result) {
      App.notifications.remove(widget._notification);
      await NotificationRepository().update(App.notifications);

      App.updateNotifications.value = !App.updateNotifications.value;

      Navigator.popUntil(context, (route) => route.isFirst);
      CustomToast()
          .showSuccessToast(Lang.getString(context, "Successfully_rated!"));
    }
  }
}
