import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/Validation.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class EditAccount extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _firstName, _lastName;

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Edit_Account"),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ResponsiveWidget.fullWidth(
                  height: 130,
                  child: DifferentSizeResponsiveRow(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          minLines: 1,
                          onSaved: (val) => _firstName = val,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(190),
                          ],
                          decoration: InputDecoration(
                            labelText: Lang.getString(context, "First_Name"),
                            hintText: Lang.getString(context, "Write_your_bio"),
                            labelStyle: Styles.labelTextStyle(),
                            hintStyle: Styles.labelTextStyle(),
                          ),
                          style: Styles.valueTextStyle(),
                          validator: (value) {
                            String valid = Validation.validate(value, context);
                            String alpha = Validation.isAlphabeticIgnoreSpaces(
                                context, value);
                            String short =
                                Validation.isShort(context, value, 20);

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
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          onSaved: (val) => _lastName = val,
                          minLines: 1,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(190),
                          ],
                          decoration: InputDecoration(
                            labelText: Lang.getString(context, "Last_Name"),
                            hintText: Lang.getString(context, "Write_your_bio"),
                            labelStyle: Styles.labelTextStyle(),
                            hintStyle: Styles.labelTextStyle(),
                          ),
                          style: Styles.valueTextStyle(),
                          validator: (value) {
                            String valid = Validation.validate(value, context);
                            String alpha = Validation.isAlphabeticIgnoreSpaces(
                                context, value);
                            String short =
                                Validation.isShort(context, value, 20);

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
                ResponsiveWidget.fullWidth(
                  height: 50,
                  child: ToggleButtons(
                    selectedColor: Styles.primaryColor(),
                    color: Styles.labelColor(),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    textStyle: Styles.valueTextStyle(),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(" " + "Male" + " "),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Female"),
                      ),
                    ],
                    onPressed: (val) {},
                    isSelected: [false, false],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 80,
        child: Column(
          children: [
            ResponsiveWidget(
              width: 270,
              height: 50,
              child: MainButton(
                text_key: "Edit",
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
