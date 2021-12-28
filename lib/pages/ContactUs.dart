import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/requests/Request.dart';
import 'package:just_miles/requests/SendContactUs.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/CustomToast.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';

class ContactUs extends StatelessWidget {
  TextEditingController nameController = new TextEditingController();
  TextEditingController subjectController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(title: Lang.getString(context, "Contact_Us")),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Row(
            children: [
              VerticalSpacer(height: 20),
            ],
          ),
          Icon(Icons.drive_eta, color: Styles.primaryColor(), size: ScreenUtil().setSp(90)),
          VerticalSpacer(height: 60),
          ResponsiveWidget(
            width: 270,
            height: 70,
            child: TextField(
                controller: subjectController,
                style: Styles.valueTextStyle(),
                decoration: InputDecoration(
                  labelText: Lang.getString(context, "Subject"),
                  labelStyle: Styles.labelTextStyle(),
                  hintStyle: Styles.labelTextStyle(),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress),
          ),
          VerticalSpacer(height: 20),
          ResponsiveWidget(
            width: 270,
            height: 150,
            child: TextField(
                controller: messageController,
                minLines: 10,
                maxLines: 50,
                style: Styles.valueTextStyle(),
                decoration: InputDecoration(
                  labelText: Lang.getString(context, "Message"),
                  labelStyle: Styles.labelTextStyle(),
                  hintStyle: Styles.labelTextStyle(),
                ),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline),
          ),
        ]),
      ),
      bottomNavigationBar: ResponsiveWidget.fullWidth(
        height: 100,
        child: Column(
          children: [
            ResponsiveWidget(
                width: 350,
                height: 50,
                child: ResponsiveRow(
                  children: [
                    MainButton(
                      textKey: "Send",
                      isRequest: true,
                      onPressed: () async {
                        Request<String> request =
                            SendContactUs(subjectController.text, messageController.text);
                        await request.send(
                            (result, error, message) => _response(result, error, message, context));
                      },
                    )
                  ],
                )),
            VerticalSpacer(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  _response(String result, int code, String message, context) async {
    if (App.handleErrors(context, code, message)) {
      return;
    }
    Navigator.pop(context);
    CustomToast().showSuccessToast(Lang.getString(context, result));
  }
}
