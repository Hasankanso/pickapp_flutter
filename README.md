# pickapp

offer and book rides

## Flutter & Dart versions

```
Flutter 1.22.4 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 1aafb3a8b9 (5 months ago) • 2020-11-13 09:59:28 -0800
Engine • revision 2c956a31c0
Tools • Dart 2.10.4
```

pubspec.yaml:

```
name: pickapp
description: offer and book rides

# The following line prevents the package from being accidentally published to
# pub.dev using `pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
version: 1.0.0+1

environment:
  sdk: ">=2.7.0 <3.0.0"

dependencies:
  flutter_material_color_picker: ^1.0.5
  flutter_datetime_picker: ^1.4.0
  shared_preferences: ^2.0.5
  flutter_google_places: ^0.2.6
  google_maps_webservice: ^0.0.16
  geolocator: ^7.0.1
  rflutter_alert: ^1.0.3
  fluttertoast: ^7.1.1
  flutter_screenutil: ^3.1.0

  mailer2: ^1.2.5
  flutter_staggered_animations: ^0.1.2
  cached_network_image: ^2.4.1
  intl: ^0.17.0
  image_picker: ^0.7.3
  hive: ^2.0.1
  hive_flutter: ^1.0.0
  path_provider: ^2.0.1
  uuid: ^3.0.3
  http: ^0.13.1
  flushbar: ^1.10.4
  firebase_core: ^1.0.2
  firebase_auth: ^1.0.1
  firebase_analytics: ^7.0.0
  firebase_messaging: ^9.1.0
  google_mobile_ads: ^0.12.0
  sliding_up_panel: ^1.0.2
  permission_handler: ^6.1.1
  flutter_local_notifications: ^5.0.0
  flutter_native_timezone: ^1.0.4
  flutter_rating_bar: ^3.2.0+1
  page_transition: ^1.1.7+6
  percent_indicator: ^2.1.9
  flutter_slidable: ^0.5.7
  flutter_native_admob: ^2.1.0+3

  flutter_localizations:
    sdk: flutter
  flutter:
    sdk: flutter


  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^1.0.1
  build_runner:

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  # To add assets to your application, add an assets section, like this:
  assets:
    - lib/images/
    - lib/languages/en.json
    - lib/languages/ar.json
    - lib/languages/fr.json

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/assets-and-images/#resolution-aware.

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/assets-and-images/#from-packages

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/custom-fonts/#from-packages
```

## Cool flutter design examples:<br>
  Menu: https://gallery.flutter.dev/#/demo/menu <br>
  Spinner: https://gallery.flutter.dev/#/demo/progress-indicator <br>
  CheckBox: https://gallery.flutter.dev/#/demo/selection-controls <br>
  Switch: https://gallery.flutter.dev/#/demo/selection-controls<br>
  Range Picker: https://gallery.flutter.dev/#/demo/sliders<br>
  TextField: https://gallery.flutter.dev/#/demo/text-field<br>
  #IOS:<br>
  Alert: https://gallery.flutter.dev/#/demo/cupertino-alerts<br>
  Activity indicator: https://gallery.flutter.dev/#/demo/cupertino-activity-indicator<br>
  Button: https://gallery.flutter.dev/#/demo/cupertino-buttons<br>
  Navigation: https://gallery.flutter.dev/#/demo/cupertino-navigation-bar<br>
  Pull to refresh: https://gallery.flutter.dev/#/demo/cupertino-pull-to-refresh<br>
  Switch: https://gallery.flutter.dev/#/demo/cupertino-switch<br>
  TextField: https://gallery.flutter.dev/#/demo/cupertino-text-field<br>
  More: https://flutter.dev/docs/development/ui/widgets/cupertino
  
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
