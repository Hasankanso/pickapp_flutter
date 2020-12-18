import 'package:flutter/material.dart';
import 'package:pickapp/classes/Styles.dart';

class CarTypeItem extends StatelessWidget {
  int _index;
  bool _isSelected;
  final String _text;
  final String _image;
  Function(int) _select;

  CarTypeItem(
      this._isSelected, this._text, this._image, this._select, this._index);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9.846153846153847),
      ),
      margin: EdgeInsets.all(10),
      child: Container(
        width: 64,
        height: 62,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.846153846153847),
          gradient: _isSelected
              ? LinearGradient(
                  colors: [Styles.lightPrimaryColor(), Styles.primaryColor()],
                )
              : null,
        ),
        child: InkWell(
          onTap: () {
            this._isSelected = true;
            _select(_index);
          },
          borderRadius: BorderRadius.circular(9.846153846153847),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: _isSelected
                          ? AssetImage(_image + '_white.png')
                          : AssetImage(_image + '_black.png'),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _text,
                      style: Styles.subValueTextStyle(
                          color: _isSelected ? Colors.white : null),
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
}
