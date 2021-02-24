import 'package:firebase_admob/firebase_admob.dart';

import 'App.dart';

class Ads {
  static BannerAd _bannerAd;
  static NativeAd _nativeAd;

  static String _bannerId, _nativeId, _rewardedId, _appId;

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static Future<void> initialize() async {
    if (App.isAndroid()) {
      _appId = 'ca-app-pub-4192057498524161~9067366925';

      _bannerId = 'ca-app-pub-4192057498524161/4614477405';
      _nativeId = 'ca-app-pub-4192057498524161/5010850615';
      _rewardedId = 'ca-app-pub-4192057498524161/8496521283';
    } else if (App.isIphone()) {
      _appId = 'ca-app-pub-4192057498524161~5864642607';

      _bannerId = 'ca-app-pub-4192057498524161/8553722413';
      _nativeId = 'ca-app-pub-4192057498524161/4117421405';
      _rewardedId = 'ca-app-pub-4192057498524161/8299234258';
    }

    await FirebaseAdMob.instance.initialize(appId: _appId);
  }

  static void displayBannerAd() async {
    if (_bannerAd == null) {
      _bannerAd = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.fullBanner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd event $event");
        },
      );
    }

    await _bannerAd.load();
    await _bannerAd.show(anchorType: AnchorType.bottom);
  }

  static void destroyBannerAd() async {
    _bannerAd?.dispose();
  }

  static void displayNativeAd() async {
    if (_nativeAd == null) {
      _nativeAd = NativeAd(
        adUnitId: NativeAd.testAdUnitId,
        factoryId: 'adFactoryExample',
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("$NativeAd event $event");
        },
      );
    }
    await _nativeAd.load();
    await _nativeAd.show();
  }

  static void destroyNativeAd() {
    _nativeAd?.dispose();
  }
}
