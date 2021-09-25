// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For justMiles, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/classes/screenutil.dart';
import 'package:just_miles/dataObjects/Person.dart';
import 'package:just_miles/dataObjects/Reservation.dart';
import 'package:just_miles/dataObjects/Ride.dart';
import 'package:just_miles/notifications/PushNotificationsManager.dart';
import 'package:just_miles/pages/RatePassengers.dart';

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
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Styles.secondaryColor())),
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
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Styles.secondaryColor())),
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
  TestWidgetsFlutterBinding.ensureInitialized();
  await Cache.init();
  await Cache.initializeHive();

  App.user = await Cache.getUser();
  if (App.user != null) {
    App.isLoggedInNotifier.value = true;
    if (App.driver != null) App.isDriverNotifier.value = true;
    //await PushNotificationsManager().init(context);
    await PushNotificationsManager().initNotifications();
  }
  testWidgets('Check Pages overflow', (WidgetTester tester) async {
    //tester.binding.window.physicalSizeTestValue = Size(720, 1280);
    tester.binding.window.clearPhysicalSizeTestValue();
    // resets the screen to its orinal size after the test end
    //addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

    Person person = new Person(firstName: "Ahmed", lastName: "Kanso");
    Reservation reservation = new Reservation(person: person);
    Ride ride = new Ride(id: "asdasd", reservations: [reservation]);
    await tester.pumpWidget(MyApp(child: RatePassengers(ride: ride)));
    await tester.pump();
    //expect(find.byElementType(ProgressButton), findsOneWidget);
  });
}
