# voomcar

offer and book rides

## Flutter & Dart versions

```
Flutter 2.5.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 18116933e7 (6 weeks ago) • 2021-10-15 10:46:35 -0700
Engine • revision d3ea636dc5
Tools • Dart 2.14.4
```

## Debugging on IOS

- Pushnotification is not supported on emulators.<br>
- Before you run the app on the simulator remove:<br>
  - pod "Unity...."
  - pod "AdColonyy"<br>
from the Pod file, then run...

## Reserve Seats manually
to reserve a seat manually enter in backendless API services or postman the following json string, the user id is the user who reserves, ride id is the ride you want to reserve a seat in.<br>
```{ "user" : {"id" : "BF44469F-86AD-41D1-905A-AED9C80CF907" }, "ride" : {"id" : "A0857336-6ED7-4292-AB05-B85F042E1C4C" }, "seats":  1, "luggages": 0 }```

## Rebuild Hive
if you've changed anything on hive and you want to rebuild:<br>
```flutter packages pub run build_runner build```<br>
if it didnt work then:<br>
```flutter packages pub run build_runner build —delete-conflicting-outputs```<br>
if still not working then, delete all `*.g.dart` files manually and try the commands mentioned above again.<br>
p.s. : `*.g.dart` files are in `lib/dataObjects` and `MainNotification.g.dart` in `lib/notifications`


## Update Password

create a token using this tutorial:
https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token

then in your project call this:

```git remote set-url origin https://<token>@github.com/<user-name>/pickapp_flutter```
