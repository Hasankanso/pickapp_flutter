import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/packages/countryPicker/Country.dart';
import 'package:pickapp/packages/countryPicker/countries_list_view.dart';
import 'package:pickapp/packages/countryPicker/country_code_to_name.dart';

class CountryPicker extends StatefulWidget {
  CountryPickerController controller;
  CountryPicker({this.controller});

  @override
  _CountryPickerState createState() => _CountryPickerState();
}

class _CountryPickerState extends State<CountryPicker> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Spacer(),
                  if (widget.controller.country != null)
                    Expanded(
                      flex: 4,
                      child: Text(
                        CountryListView.countryCodeToEmoji(
                            widget.controller.country.countryCode),
                        style: Styles.titleTextStyle(),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  if (widget.controller.country != null)
                    Spacer(
                      flex: 2,
                    ),
                  Expanded(
                    flex: 35,
                    child: Text(
                      widget.controller.country != null
                          ? en[widget.controller.country.countryCode]
                          : Lang.getString(context, "Choose_country"),
                      style: Styles.valueTextStyle(),
                      overflow: TextOverflow.clip,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          showDialog(
              context: context,
              barrierColor: Colors.black12,
              barrierDismissible: false,
              builder: (_) => Center(
                    child: Container(
                      width: ScreenUtil().setWidth(330),
                      height: ScreenUtil().setHeight(600),
                      decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Spacer(),
                                IconButton(
                                  padding: const EdgeInsets.all(0),
                                  iconSize: 20,
                                  icon: Icon(Icons.close),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 23,
                            child: CountryListView(
                              showPhoneCode: false,
                              onSelect: (c) {
                                setState(() {
                                  widget.controller.country = c;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
        });
  }
}

class CountryPickerController {
  Country country;
  CountryPickerController({this.country});

  validate(context, {CountryPickerController x}) {
    if (this.country == null) {
      return Lang.getString(context, "Choose_country");
    } else {
      return null;
    }
  }
}
