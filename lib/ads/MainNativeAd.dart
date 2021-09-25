import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_miles/ads/Ads.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/Spinner.dart';

class MainNativeAd extends StatelessWidget {
  NativeAd _nativeAd;
  final Decoration decoration;
  MainNativeAd({this.decoration});
  final Completer<NativeAd> _nativeAdCompleter = Completer<NativeAd>();

  @override
  Widget build(BuildContext context) {
    _nativeAd = NativeAd(
      adUnitId: Ads.nativeId,
      request: Ads.adRequest,
      factoryId: 'adFactoryID',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          _nativeAdCompleter.complete(ad as NativeAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$NativeAd failedToLoad: $error');
          _nativeAdCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        onAdWillDismissScreen: (Ad ad) =>
            print('$NativeAd onAdWillDismissScreen.'),
      ),
    );

    Future<void>.delayed(Duration(seconds: 1), () => _nativeAd.load());

    return FutureBuilder<NativeAd>(
      future: _nativeAdCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<NativeAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            child = Center(
              child: Spinner(),
            );
            break;
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _nativeAd);
            } else {
              child = Center(
                child: Text(
                  'Error loading Advertisement',
                  style: Styles.valueTextStyle(),
                ),
              );
            }
        }
        return Container(
          decoration: decoration,
          child: child,
        );
      },
    );
  }
}
