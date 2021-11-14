import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/Validation.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Rate.dart';
import 'package:just_miles/utilities/Responsive.dart';

class PassengerRateTile extends StatefulWidget {
  final Rate rate;
  final GlobalKey<FormState> formKey;

  PassengerRateTile(this.rate, this.formKey, {Key key}) : super(key: key);

  @override
  _PassengerRateTileState createState() => _PassengerRateTileState();

  static Function(BuildContext, int) createPassengersItems(
      List<Rate> rates, List<GlobalKey<FormState>> formKey) {
    return (context, index) {
      return PassengerRateTile(rates[index], formKey[index]);
    };
  }
}

class _PassengerRateTileState extends State<PassengerRateTile> {
  bool _isReasonVisible = false;
  List<String> _reasonsItems;
  TextEditingController commentController = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reasonsItems = App.getRateReasons(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: _isReasonVisible ? 350 : 280,
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        widget.rate.target.firstName +
                            " " +
                            widget.rate.target.lastName,
                        style: Styles.valueTextStyle(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: RatingBar.builder(
                    initialRating: 0,
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
                      widget.rate.grade = rating;

                      setState(() {
                        if (rating <= Rate.maximumRateReasonRequired)
                          _isReasonVisible = true;
                        else
                          _isReasonVisible = false;
                      });
                    },
                  ),
                ),
                if (_isReasonVisible) Spacer(flex: 1),
                if (_isReasonVisible)
                  Expanded(
                    flex: 4,
                    child: ResponsiveWidget.fullWidth(
                      height: 115,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 2),
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                              labelText: Lang.getString(context, "Reason")),
                          value: _reasonsItems[0],
                          onChanged: (String newValue) {},
                          items: _reasonsItems
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  flex: _isReasonVisible ? 8 : 12,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                    child: TextFormField(
                      onChanged: (value) {
                        widget.rate.comment = value;
                      },
                      controller: commentController,
                      minLines: 4,
                      textInputAction: TextInputAction.done,
                      maxLines: 20,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(400),
                      ],
                      decoration: InputDecoration(
                        labelText: Lang.getString(context, "Review"),
                        labelStyle: Styles.labelTextStyle(),
                        hintStyle: Styles.labelTextStyle(),
                      ),
                      style: Styles.valueTextStyle(),
                      validator: (value) {
                        String valid = Validation.validate(value, context);
                        String alpha = Validation.isAlphaNumericIgnoreSpaces(
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
                ),
              ],
            ),
          )),
    );
  }
}
