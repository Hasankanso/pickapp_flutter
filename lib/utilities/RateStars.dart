import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';

class RateStars extends StatelessWidget {
  double _rating;
  MainAxisAlignment mainAxisAlignment;
  Function onPressed;
  double size;

  RateStars(this._rating, {this.mainAxisAlignment, this.onPressed, this.size});

  @override
  Widget build(BuildContext context) {
    size = size == null ? Styles.mediumIconSize() : size;

    if (onPressed != null) {
      return Row(
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.transparent,
            size: Styles.mediumIconSize(),
          ),
          TextButton(
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: mainAxisAlignment == null
                  ? MainAxisAlignment.center
                  : mainAxisAlignment,
              children: List<Widget>.generate(6, (int index) {
                if (index == 5) {
                  return Directionality(
                      textDirection:
                          App.isLTR ? TextDirection.ltr : TextDirection.rtl,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey.withOpacity(0.5),
                        size: size,
                      ));
                }
                if (_rating >= index + 1) {
                  return Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: size,
                  );
                } else if (_rating.toInt() == index &&
                    _rating.toInt() != _rating) {
                  return Icon(
                    Icons.star_half,
                    color: Colors.yellow,
                    size: size,
                  );
                } else {
                  return Icon(
                    Icons.star,
                    color: Colors.grey.withOpacity(0.5),
                    size: size,
                  );
                }
              }),
            ),
          ),
        ],
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
              size: size,
            );
          } else if (_rating.toInt() == index && _rating.toInt() != _rating) {
            return Icon(
              Icons.star_half,
              color: Colors.yellow,
              size: size,
            );
          } else {
            return Icon(
              Icons.star,
              color: Colors.grey.withOpacity(0.5),
              size: size,
            );
          }
        }),
      );
    }
  }
}
