import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as Svg;
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/Buttons.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';
import 'package:just_miles/utilities/Responsive.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';

class NewVersion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Update"),
        leading: App.appNeedForceUpdate ? Container() : null,
      ),
      body: Column(
        children: [
          VerticalSpacer(
            height: 150,
          ),
          Image(
              image: Svg.Svg('lib/images/voomcar_logo.svg',
                  size: const Size(210 * 1.4, 38.8 * 1.4))),
          VerticalSpacer(
            height: 120,
          ),
          if (App.appNeedForceUpdate)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${App.appName} ${Lang.getString(context, "Needs_an_update")}",
                  style: Styles.valueTextStyle(),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "${Lang.getString(context, "Update_msg1")} ${App.appName}," +
                        " ${Lang.getString(context, "Update_msg2")}",
                    style: Styles.valueTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          if (App.appRecommendUpdate)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "${App.appName} ${Lang.getString(context, "Recommend_update_msg")}",
                    style: Styles.valueTextStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
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
                isRequest: false,
                textKey: "Update",
                onPressed: () async {
                  if (Platform.isAndroid || Platform.isIOS) {
                    LaunchReview.launch(
                        androidAppId: App.playStoreId,
                        iOSAppId: App.appStoreId);
                  } else {
                    if (await canLaunch(App.websiteUrl)) {
                      await launch(
                        App.websiteUrl,
                        forceSafariVC: false,
                        forceWebView: false,
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
