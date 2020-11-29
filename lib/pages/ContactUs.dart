import 'package:flutter/material.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';

class ContactUs extends StatelessWidget {
  TextEditingController c1 = new TextEditingController();
  TextEditingController c2 = new TextEditingController();
  TextEditingController c3 = new TextEditingController();

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
          Icon(Icons.drive_eta,
              color: Styles.primaryColor(), size: ScreenUtil().setSp(90)),
          VerticalSpacer(height : 20),
          ResponsiveWidget(
            width: 270,
            height: 50,
            child: TextField(
              controller: c1,
              style: Styles.valueTextStyle(),
              decoration: InputDecoration(
                labelText: Lang.getString(context, "Full_Name"),
                hintText: Lang.getString(context, "Full_Name"),
                labelStyle: Styles.labelTextStyle(),
                hintStyle: Styles.labelTextStyle(),
              ),
              keyboardType: TextInputType.name,
            ),
          ),
          VerticalSpacer(height: 20),
          ResponsiveWidget(
            width: 270,
            height: 50,
            child: TextField(
                controller: c2,
                style: Styles.valueTextStyle(),
                decoration: InputDecoration(
                  labelText: Lang.getString(context, "Subject"),
                  hintText: Lang.getString(context, "Subject"),
                  labelStyle: Styles.labelTextStyle(),
                  hintStyle: Styles.labelTextStyle(),
                ),
                keyboardType: TextInputType.emailAddress),
          ),
          VerticalSpacer(height: 60),
          ResponsiveWidget(
            width: 270,
            height: 150,
            child: TextField(
                controller: c3,
                minLines: 10,
                maxLines: 40,
                style: Styles.valueTextStyle(),
                decoration: InputDecoration(
                  labelText: Lang.getString(context, "Message"),
                  hintText: Lang.getString(context, "Message"),
                  labelStyle: Styles.labelTextStyle(),
                  hintStyle: Styles.labelTextStyle(),
                ),
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
                    text_key: "Send",
                    onPressed: () {},
                  )],
                )),
            VerticalSpacer(height: 50,),
          ],
        ),
      ),
    );
  }
}
