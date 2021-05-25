import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/Reservation.dart';
import 'package:pickapp/utilities/Responsive.dart';

class PassengerRateTile extends ListTile {
  final Reservation reservation;
  final commentController;

  PassengerRateTile(this.reservation, {this.commentController, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.fullWidth(
      height: 300,
      child: Card(
          elevation: 3.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
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
                      reservation.person.firstName + " " + reservation.person.lastName,
                      style: Styles.valueTextStyle(),
                    ),
                  ],
                ),
              ),
              Spacer(),
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
                  onRatingUpdate: (rating) {},
                ),
              ),
              Spacer(flex: 2),
              Expanded(
                flex: 8,
                child: TextFormField(
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
                    String alpha = Validation.isAlphaNumericIgnoreSpaces(context, value);

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
          )),
    );
  }

  static Function(BuildContext, int) createPassengersItems(List<Reservation> passengers) {
    return (context, index) {
      return PassengerRateTile(passengers[index]);
    };
  }
}
