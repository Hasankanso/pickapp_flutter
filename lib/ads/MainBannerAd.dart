import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_miles/ads/Ads.dart';

class MainBannerAd extends StatelessWidget {
  BannerAd _bannerAd;
  final Completer<BannerAd> _bannerAdCompleter = Completer<BannerAd>();

  @override
  Widget build(BuildContext context) {
    _bannerAd = BannerAd(
      adUnitId: Ads.bannerId,
      size: AdSize.fullBanner,
      request: Ads.adRequest,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$NativeAd loaded.');
          _bannerAdCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$NativeAd failedToLoad: $error');
          _bannerAdCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$NativeAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$NativeAd onAdClosed.'),
        onAdWillDismissScreen: (Ad ad) =>
            print('$NativeAd onAdWillDismissScreen.'),
      ),
    );

    Future<void>.delayed(Duration(seconds: 1), () => _bannerAd.load());

    return FutureBuilder<BannerAd>(
      future: _bannerAdCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd);
            } else {
              child = Text('Error loading $NativeAd');
            }
        }

        return Container(
          alignment: Alignment.center,
          child: child,
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
        );
      },
    );
  }
}
