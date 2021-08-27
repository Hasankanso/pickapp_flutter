import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_miles/ads/Ads.dart';

class MainNativeAd extends StatelessWidget {
  NativeAd _nativeAd;
  final Completer<NativeAd> _nativeAdCompleter = Completer<NativeAd>();

  @override
  Widget build(BuildContext context) {
    _nativeAd = NativeAd(
      adUnitId: Ads.nativeId,
      request: Ads.adRequest,
      factoryId: 'adFactoryID',
      listener: AdListener(
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
        onApplicationExit: (Ad ad) => print('$NativeAd onApplicationExit.'),
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
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _nativeAd);
            } else {
              child = Text('Error loading $NativeAd');
            }
        }

        return Container(
          child: child,
        );
      },
    );
  }
}
