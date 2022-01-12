import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_miles/classes/App.dart';
import 'package:just_miles/utilities/Spinner.dart';

class Ads {
  static RewardedAd _rewardedAd;
  static int _numRewardedLoadAttempts = 0;
  static String bannerId, nativeId, _rewardedId;
  static int _maxFailedLoadAttempts = 3;
  static bool _isRewarded = false;

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
    await RewardedAd.load(
        adUnitId: _rewardedId,
        request: adRequest,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= _maxFailedLoadAttempts) {
              loadRewardedAd();
            }
          },
        ));
  }

  static Future<void> showRewardedAd(Function callBack, context) async {
    if (_rewardedAd == null) {
      return;
    }
    _isRewarded = false;
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        loadRewardedAd();
        if (!_isRewarded) {
          //if user didn't watch the whole video, just pop the spinner
          Navigator.pop(context);
        }
      },
      onAdWillDismissFullScreenContent: (RewardedAd ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();

        Navigator.pop(context);
        loadRewardedAd();
      },
    );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Spinner(),
          ),
        );
      },
    );
    _rewardedAd.setImmersiveMode(true);
    _rewardedAd.show(
      onUserEarnedReward: (RewardedAd ad, RewardItem reward) {
        _isRewarded = true;
        if (callBack != null) callBack();
      },
    );
    _rewardedAd = null;
  }
}
