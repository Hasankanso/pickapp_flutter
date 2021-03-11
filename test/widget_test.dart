// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pickapp/classes/App.dart';
import 'package:pickapp/classes/Cache.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';
import 'package:pickapp/classes/screenutil.dart';
import 'package:pickapp/notifications/PushNotificationsManager.dart';
import 'package:pickapp/pages/Login.dart';
import 'package:pickapp/pages/Search.dart';


class InitializerWidget extends StatefulWidget {
  final Widget child;
  InitializerWidget({this.child});

  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget> {

  @override
  void didChangeDependencies() {
    ScreenUtil.init(context);
    App.setContext(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class MyApp extends StatelessWidget {
  final Locale _locale = Locale("en");
  final Widget child;

  MyApp({this.child});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      navigatorKey: App.navKey,
      title: App.appName,
      locale: _locale,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Styles.primaryColor(),
        accentIconTheme: IconThemeData(color: Styles.labelColor()),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Styles.primaryColor(),
          foregroundColor: Styles.primaryColor(),
        ),
        primaryTextTheme:
        TextTheme(headline6: TextStyle(color: Styles.secondaryColor())),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: Styles.currentTheme(),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Styles.secondaryColor(),
        primarySwatch: Styles.primaryColor(),
        toggleableActiveColor: Styles.primaryColor(),
        textSelectionHandleColor: Styles.primaryColor(),
        textSelectionColor: Styles.highlitedPrimary(),
        accentIconTheme: IconThemeData(color: Styles.secondaryColor()),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Styles.primaryColor(),
          foregroundColor: Styles.primaryColor(),
        ),
        primaryTextTheme:
        TextTheme(headline6: TextStyle(color: Styles.secondaryColor())),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      supportedLocales: Lang.langs.map((element) => Locale(element.code)),
      localizationsDelegates: [
        Lang.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      home: InitializerWidget(child: child),
    );
  }
}


void main() async {
  await Cache.init();
  await Cache.initializeHive();

  App.user = await Cache.getUser();
  if (App.user != null) {
    App.isLoggedInNotifier.value = true;
    if (App.driver != null) App.isDriverNotifier.value = true;
    await PushNotificationsManager().init();
    await PushNotificationsManager().handleNotifications();
  }

  testWidgets('Check Pages overflow', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = Size(720, 1280);
    // resets the screen to its orinal size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    await tester.pumpWidget(MyApp(child : Search()));
    await tester.pump();

    await tester.pumpWidget(MyApp(child : Login()));
    await tester.pump();
    //expect(find.byElementType(ProgressButton), findsOneWidget);
  });
}
