import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pickapp/utilities/CustomToast.dart';

import 'App.dart';

class Ads {
  static BannerAd _bannerAd;
 // check https://pub.dev/packages/google_mobile_ads
  static String _bannerId, nativeId, _rewardedId, _appId;

  static final AdListener listener = AdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an ad is in the process of leaving the application.
    onApplicationExit: (Ad ad) => print('Left application.'),
  );

  /*
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );
*/

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

    MobileAds.instance.initialize();
    //await FirebaseAdMob.instance.initialize(appId: _appId);
  }

  /*
  static void displayBannerAd() async {
    if (_bannerAd == null) {
      _bannerAd = BannerAd(
        adUnitId:  BannerAd.testAdUnitId,
        size: AdSize.banner,
        request: AdRequest(),
        listener: listener,
      );
    }

    await _bannerAd.load();
    print(_bannerAd.toString());
    await _bannerAd.show(anchorType: AnchorType.bottom);
  }
*/

  static void destroyBannerAd() async {
    _bannerAd?.dispose();
  }

  static bool rewardedAdLoaded = false;
/*
  static void loadRewardedVideo(BuildContext context, callback) async {
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        callback();
      } else if (event == RewardedVideoAdEvent.loaded) {
        rewardedAdLoaded = true;
      } else if (event == RewardedVideoAdEvent.failedToLoad) {
        rewardedAdLoaded = false;
        CustomToast().showErrorToast("something_wrong_check_internet");
      }
    };
    await RewardedVideoAd.instance.load(
        adUnitId: RewardedVideoAd.testAdUnitId, targetingInfo: targetingInfo);
    showRewardedAd();
  }

  static Future<void> showRewardedAd() async {
    if (rewardedAdLoaded) {
      await RewardedVideoAd.instance.show();
    }
  }

*/

  static final banner = BannerAd(
  adUnitId:  BannerAd.testAdUnitId,
  size: AdSize.banner,
  request: AdRequest(),
  listener: listener,
  );

  static final NativeAd native = NativeAd(
    adUnitId: NativeAd.testAdUnitId,
    factoryId: 'adFactoryID',
    request: AdRequest(),
    listener: listener,
  );

/*
  @Override
  public UnifiedNativeAdView createNativeAd(
      UnifiedNativeAd nativeAd, Map<String, Object> customOptions) {
    final UnifiedNativeAdView adView =
    (UnifiedNativeAdView) layoutInflater.inflate(R.layout.my_native_ad, null);
    final TextView headlineView = adView.findViewById(R.id.ad_headline);
    final TextView bodyView = adView.findViewById(R.id.ad_body);

    headlineView.setText(nativeAd.getHeadline());
    bodyView.setText(nativeAd.getBody());

    adView.setBackgroundColor(Color.YELLOW);

    adView.setNativeAd(nativeAd);
    adView.setBodyView(bodyView);
    adView.setHeadlineView(headlineView);
    return adView;
  }
}
*/
}
