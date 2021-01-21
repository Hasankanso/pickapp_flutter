import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

class RateStars extends StatelessWidget {
  double _rating;
  MainAxisAlignment mainAxisAlignment;
  Function onPressed;
  RateStars(this._rating, {this.mainAxisAlignment, this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (onPressed != null) {
      return RaisedButton(
        onPressed: onPressed,
        color: Colors.grey.shade200,
        splashColor: Colors.grey.shade300,
        highlightColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: mainAxisAlignment == null
              ? MainAxisAlignment.center
              : mainAxisAlignment,
          children: List<Widget>.generate(5, (int index) {
            if (_rating >= index + 1) {
              return Icon(
                Icons.star,
                color: Colors.yellow,
                size: Styles.mediumIconSize(),
              );
            } else if (_rating.toInt() == index && _rating.toInt() != _rating) {
              return Icon(
                Icons.star_half,
                color: Colors.yellow,
                size: Styles.mediumIconSize(),
              );
            } else {
              return Icon(
                Icons.star,
                color: Colors.grey.withOpacity(0.5),
                size: Styles.mediumIconSize(),
              );
            }
          }),
        ),
      );
    } else {
      return Row(
        mainAxisAlignment: mainAxisAlignment == null
            ? MainAxisAlignment.center
            : mainAxisAlignment,
        children: List<Widget>.generate(5, (int index) {
          if (_rating >= index + 1) {
            return Icon(
              Icons.star,
              color: Colors.yellow,
              size: Styles.mediumIconSize(),
            );
          } else if (_rating.toInt() == index && _rating.toInt() != _rating) {
            return Icon(
              Icons.star_half,
              color: Colors.yellow,
              size: Styles.mediumIconSize(),
            );
          } else {
            return Icon(
              Icons.star,
              color: Colors.grey.withOpacity(0.5),
              size: Styles.mediumIconSize(),
            );
          }
        }),
      );
    }
  }
}
