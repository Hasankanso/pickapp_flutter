import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

class RateStars extends StatelessWidget {
  double rating;
  RateStars({this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(children: _createChildren());
  }

  List<Widget> _createChildren() {
    return new List<Widget>.generate(5, (int index) {
      if (rating >= index + 1) {
        return Icon(
          Icons.star,
          color: Colors.yellow,
          size: Styles.mediumIconSize(),
        );
      } else if (rating.toInt() == index && rating.toInt() != rating) {
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
    });
  }
}
