import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/dataObjects/User.dart';
import 'package:pickapp/utilities/Buttons.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';
import 'package:pickapp/utilities/Responsive.dart';
import 'package:mailer2/mailer.dart';

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
          Icon(Icons.drive_eta,
              color: Styles.primaryColor(), size: ScreenUtil().setSp(90)),
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
                      onPressed: () {
                        print(subjectController.text);
                        print(messageController.text);
                        var options = new GmailSmtpOptions()
                          ..username = 'team2020management@gmail.com'
                          ..password = r'SexyVibes@online#$'; // Note: if you have Google's "app specific passwords" enabled,
                        // you need to use one of those here.

                        // How you use and store passwords is up to you. Beware of storing passwords in plain.

                        // Create our email transport.
                        var emailTransport = new SmtpTransport(options);
                        User user = App.user;
                        assert(user !=null);
                        // Create our mail/envelope.
                        var envelope = new Envelope()
                          ..from = user.email
                         ..recipients.add("team2020management@gmail.com")
  //                        ..bccRecipients.add('hidden@recipient.com')
                          ..subject = "[" + user.email + "] " + user.person.firstName + " " + user.person.lastName +": " + subjectController.text
//                          ..attachments.add(
  //                            new Attachment(file: new File('path/to/file')))
                          ..text = messageController.text;

                        // Email it.
                        emailTransport
                            .send(envelope)
                            .then((envelope) => print('Email sent!'))
                            .catchError((e) => print('Error occurred: $e'));
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
}
