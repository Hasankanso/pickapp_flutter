import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../classes/App.dart';

class Ads {
  static RewardedAd _rewardedAd;
  static int _numRewardedLoadAttempts = 0;
  static String bannerId, nativeId, _rewardedId;
  static int maxFailedLoadAttempts = 3;

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
      status.adapterStatuses.forEach((key, value) {
        debugPrint('Adapter status for $key: ${value.state}');
      });
      MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        tagForChildDirectedTreatment: _childTreatment,
        tagForUnderAgeOfConsent: _childTreatment,
      ));
    });
  }

  static Future<void> loadRewardedAd() async {
    await RewardedAd.load(
        adUnitId: _rewardedId,
        request: adRequest,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              loadRewardedAd();
            }
          },
        ));
  }

  static Future<void> showRewardedAd(Function callBack) async {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );
    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
      if (callBack != null) callBack();
    });
    _rewardedAd = null;
  }
}
