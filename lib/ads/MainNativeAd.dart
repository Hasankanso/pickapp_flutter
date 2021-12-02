import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_miles/ads/Ads.dart';
import 'package:just_miles/classes/Styles.dart';
import 'package:just_miles/utilities/Spinner.dart';

class MainNativeAd extends StatefulWidget {
  final Decoration decoration;

  MainNativeAd({this.decoration});

  @override
  _MainNativeAdState createState() => _MainNativeAdState();
}

class _MainNativeAdState extends State<MainNativeAd> {
  NativeAd _nativeAd;
  Future<NativeAd> adLoader;

  final Completer<NativeAd> _nativeAdCompleter = Completer<NativeAd>();

  Future<NativeAd> loadAd() async {
    _nativeAd = NativeAd(
      adUnitId: Ads.nativeId,
      request: Ads.adRequest,
      factoryId: 'adFactoryID',
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          _nativeAdCompleter.complete(ad as NativeAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();

          _nativeAdCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdWillDismissScreen: (Ad ad) {},
      ),
    );

    await _nativeAd.load();

    return await _nativeAdCompleter.future;
  }

  @override
  void initState() {
    adLoader = loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NativeAd>(
      future: adLoader,
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
          decoration: widget.decoration,
          child: child,
        );
      },
    );
  }
}
