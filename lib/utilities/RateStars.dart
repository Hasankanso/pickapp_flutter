import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Styles.dart';

class RateStars extends StatelessWidget {
  double _rating;
  final MainAxisAlignment mainAxisAlignment;
  final Function onPressed;
  double size;
  IconData _starIcon = Icons.star;
  Color _iconColor = Colors.yellow;
  int maxStars;

  RateStars(this._rating,
      {this.mainAxisAlignment,
      this.onPressed,
      this.size,
      IconData customIcon,
      Color customColor,
      this.maxStars = 5}) {
    _rating = App.roundRate(_rating);
    size = size == null ? Styles.mediumIconSize() : size;

    if (customIcon != null) {
      this._starIcon = customIcon;
    }

    if (customColor != null) {
      this._iconColor = customColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (onPressed != null) {
      return Row(
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.transparent,
            size: Styles.mediumIconSize(),
          ),
          GestureDetector(
            onTap: onPressed,
            child: Row(
              mainAxisAlignment:
                  mainAxisAlignment == null ? MainAxisAlignment.center : mainAxisAlignment,
              children: List<Widget>.generate(maxStars + 1, (int index) {
                if (index == 5) {
                  return Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.withOpacity(0.5),
                    size: size,
                  );
                }
                if (_rating >= index + 1) {
                  return Icon(
                    _starIcon,
                    color: _iconColor,
                    size: size,
                  );
                } else if (_rating.toInt() == index && _rating.toInt() != _rating) {
                  return Icon(
                    Icons.star_half,
                    color: _iconColor,
                    size: size,
                  );
                } else {
                  return Icon(
                    _starIcon,
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
        mainAxisAlignment: mainAxisAlignment == null ? MainAxisAlignment.center : mainAxisAlignment,
        children: List<Widget>.generate(maxStars, (int index) {
          if (_rating >= index + 1) {
            return Icon(
              _starIcon,
              color: _iconColor,
              size: size,
            );
          } else if (_rating.toInt() == index && _rating.toInt() != _rating) {
            return Icon(
              Icons.star_half,
              color: _iconColor,
              size: size,
            );
          } else {
            return Icon(
              _starIcon,
              color: Colors.grey.withOpacity(0.5),
              size: size,
            );
          }
        }),
      );
    }
  }
}
