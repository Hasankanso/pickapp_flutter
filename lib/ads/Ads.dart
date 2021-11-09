import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../classes/App.dart';

class Ads {
  static RewardedAd _rewardedAd;
  static bool _rewardedReady = false;
  static String bannerId, nativeId, _rewardedId;

  static AdRequest adRequest = AdRequest(
    nonPersonalizedAds: true,
  );

  static Future<void> initialize() async {
    if (App.isAndroid()) {
      bannerId = 'ca-app-pub-4192057498524161/4614477405';
      nativeId = 'ca-app-pub-4192057498524161/5010850615';
      _rewardedId = 'ca-app-pub-4192057498524161/8496521283';
    } else if (App.isIphone()) {
      bannerId = 'ca-app-pub-4192057498524161/8553722413';
      nativeId = 'ca-app-pub-4192057498524161/4117421405';
      _rewardedId = 'ca-app-pub-4192057498524161/8299234258';
    }

    int _childTreatment = TagForUnderAgeOfConsent.unspecified;

    if (App.user != null) {
      int age = App.calculateAge(App.person.birthday);
      if (age > 18)
        _childTreatment = TagForUnderAgeOfConsent.no;
      else
        _childTreatment = TagForUnderAgeOfConsent.yes;
    }

    MobileAds.instance.initialize().then((InitializationStatus status) {
      MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        tagForChildDirectedTreatment: _childTreatment,
        tagForUnderAgeOfConsent: _childTreatment,
      ));
    });
  }

  static Future<void> loadRewardedAd() async {
    if (_rewardedReady) return;
    await RewardedAd.load(
      adUnitId: _rewardedId,
      request: adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) async {
          print('${ad.runtimeType} loaded..');
          _rewardedReady = true;
          _rewardedAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _rewardedAd = null;
          print("failed to load");
        },
      ),
    );
  }

  static Future<void> showRewardedAd(Function callBack) async {
    if (!_rewardedReady) return;

    await _rewardedAd.show(
      onUserEarnedReward: (RewardedAd ad, RewardItem rewardItem) {
        _rewardedReady = false;
        if (callBack != null) callBack();
      },
    );
  }
}
