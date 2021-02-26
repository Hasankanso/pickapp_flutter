import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:pickapp/utilities/CustomToast.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

import 'App.dart';

class Ads {
  static BannerAd _bannerAd;
  
  static String _bannerId, nativeId, _rewardedId, _appId;

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
      nativeId = 'ca-app-pub-4192057498524161/5010850615';
      _rewardedId = 'ca-app-pub-4192057498524161/8496521283';

    } else if (App.isIphone()) {
      _appId = 'ca-app-pub-4192057498524161~5864642607';

      _bannerId = 'ca-app-pub-4192057498524161/8553722413';
      nativeId = 'ca-app-pub-4192057498524161/4117421405';
      _rewardedId = 'ca-app-pub-4192057498524161/8299234258';
    }

    //#TODO remove el TEST nambar
    nativeId = "ca-app-pub-3940256099942544/2247696110";

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

  static bool rewardedAdLoaded = false;
  static void loadRewardedVideo(BuildContext context, callback) async {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        callback();
      } else if (event == RewardedVideoAdEvent.loaded) {
        rewardedAdLoaded = true;
      } else if (event == RewardedVideoAdEvent.failedToLoad){
        rewardedAdLoaded = false;
        CustomToast().showErrorToast("something_wrong_check_internet");
      }
    };
    await RewardedVideoAd.instance
        .load(adUnitId: _rewardedId, targetingInfo: targetingInfo);
    showRewardedAd();
  }

  static Future<void> showRewardedAd() async {
    if (rewardedAdLoaded) {
      await RewardedVideoAd.instance.show();
    }
  }

  static void nativeAd(){


  }

}
