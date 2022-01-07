import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/items/NotificationListTile.dart';
import 'package:just_miles/notifications/MainNotification.dart';
import 'package:just_miles/notifications/PushNotificationsManager.dart';
import 'package:just_miles/utilities/ListBuilder.dart';
import 'package:just_miles/utilities/MainAppBar.dart';
import 'package:just_miles/utilities/MainScaffold.dart';

class Notifications extends StatelessWidget {
  List<MainNotification> notifications;

  @override
  Widget build(BuildContext context) {
    PushNotificationsManager().initNotifications();
    return ValueListenableBuilder(
        valueListenable: App.updateNotifications,
        builder: (BuildContext context, bool isd, Widget child) {
          WidgetsBinding.instance.addPostFrameCallback(
              (_) => App.isNewNotificationNotifier.value = false);
          Cache.setIsNewNotification(false);
          notifications = List.from(App.notifications.reversed);
          assert(notifications != null);
          return MainScaffold(
            appBar: MainAppBar(
              title: Lang.getString(context, "Notifications"),
            ),
            body: Container(
              child: notifications.length > 0
                  ? ListBuilder(
                      list: notifications,
                      itemBuilder:
                          NotificationListTile.itemBuilder(notifications),
                      nativeAdHeight: ScreenUtil().setSp(60),
                      nativeAdElevation: 1,
                      nativeAdRoundCorner: 5)
                  : Center(
                      child: Text(Lang.getString(context, "No_notifications!"),
                          style: Styles.valueTextStyle())),
            ),
          );
        });
  }
}
