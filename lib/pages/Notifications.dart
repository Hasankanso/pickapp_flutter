import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/items/NotificationListTile.dart';
import 'package:pickapp/notifications/MainNotification.dart';
import 'package:pickapp/utilities/ListBuilder.dart';
import 'package:pickapp/utilities/MainAppBar.dart';
import 'package:pickapp/utilities/MainScaffold.dart';

class Notifications extends StatelessWidget {
  List<MainNotification> notifications = List<MainNotification>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => App.isNewNotificationNotifier.value = false);

    return MainScaffold(
      appBar: MainAppBar(
        title: Lang.getString(context, "Notifications"),
      ),
      body: Container(
        child: notifications.length > 0
            ? ListBuilder(
                list: notifications,
                itemBuilder: NotificationListTile.itemBuilder(notifications))
            : Center(
                child: Text(Lang.getString(context, "No_notifications!"),
                    style: Styles.valueTextStyle())),
      ),
    );
  }
}
