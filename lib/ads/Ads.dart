import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../classes/App.dart';

class Ads {
  static RewardedAd _rewardedAd;
  static bool _rewardedReady = false;
  static String bannerId, nativeId, _rewardedId;

  static List<String> testDevices = ["CCFDAC7398A8A50F2A79982FEB7459E2"];

  static AdRequest adRequest = AdRequest(
    testDevices: Ads.testDevices,
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

  static Future<void> createRewardedAd(Function callBack) async {
    _rewardedAd =  RewardedAd(
      adUnitId: _rewardedId,
      request: adRequest,
      listener: AdListener(
          onAdLoaded: (Ad ad) {
            print('${ad.runtimeType} loaded.');
            _rewardedReady = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            print('${ad.runtimeType} failed to load: $error');
            ad.dispose();
            _rewardedAd = null;
          },
          onAdOpened: (Ad ad) => print('${ad.runtimeType} onAdOpened.'),
          onAdClosed: (Ad ad) {
            print('${ad.runtimeType} closed.');
            ad.dispose();
          },
          onApplicationExit: (Ad ad) =>
              print('${ad.runtimeType} onApplicationExit.'),
          onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
            print(
              '$RewardedAd with reward $RewardItem(${reward.amount}, ${reward.type})',
            );
            if (callBack != null) callBack();
          }),
    );
   await  _rewardedAd.load();
  }

  //call this method to show rewarded ad;
  static Future<void> showRewardedAd() async {
    if (!_rewardedReady) return;
   await  _rewardedAd.show();
    _rewardedReady = false;
    _rewardedAd = null;
  }
}
