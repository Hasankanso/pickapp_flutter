import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:pickapp/classes/Ads.dart';
import 'package:pickapp/classes/Localizations.dart';
import 'package:pickapp/classes/Styles.dart';

import 'Spinner.dart';

const _viewType = "native_admob";

enum NativeAdmobType { banner, full }

class MainNativeAd extends StatefulWidget {
  final int numberAds;
  final bool isBanner;
  final NativeAdmobController controller;

  MainNativeAd({
    Key key,
    this.controller,
    this.numberAds = 1,
    this.isBanner = false,
  }) : super(key: key);

  @override
  _MainNativeAdState createState() => _MainNativeAdState();
}

class _MainNativeAdState extends State<MainNativeAd> {
  static final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  static final isiOS = defaultTargetPlatform == TargetPlatform.iOS;

  NativeAdmobController _nativeAdController;

  NativeAdmobOptions get _options => NativeAdmobOptions(
        adLabelTextStyle: NativeTextStyle(
            color: Colors.white,
            fontSize: 10,
            backgroundColor: Styles.primaryColor()),
        headlineTextStyle: NativeTextStyle(
          color: Styles.primaryColor(),
          fontSize: Styles.fontSize(),
        ),
        advertiserTextStyle: NativeTextStyle(
          color: Styles.labelColor(),
          fontSize: Styles.fontSize(),
        ),
        bodyTextStyle: NativeTextStyle(
            color: Styles.valueColor(), fontSize: Styles.fontSize()),
        callToActionStyle: NativeTextStyle(
            color: Styles.secondaryColor(),
            fontSize: Styles.fontSize(),
            backgroundColor: Styles.primaryColor()),
        ratingColor: Colors.yellow,
        priceTextStyle: NativeTextStyle(
            color: Styles.valueColor(), fontSize: Styles.fontSize()),
        storeTextStyle: NativeTextStyle(
            color: Styles.labelColor(), fontSize: Styles.fontSize()),
      );
  NativeAdmobType get _type =>
      !widget.isBanner ? NativeAdmobType.full : NativeAdmobType.banner;

  Widget get _loading => Center(child: Spinner());

  Widget get _error => Center(
          child: Text(
        Lang.getString(context, "Failed_load_ad"),
        style: Styles.valueTextStyle(),
      ));

  var _loadState = AdLoadState.loading;
  StreamSubscription _subscription;

  @override
  void initState() {
    _nativeAdController = widget.controller ?? NativeAdmobController();
    _nativeAdController.setAdUnitID(Ads.nativeId, numberAds: widget.numberAds);

    _subscription = _nativeAdController.stateChanged.listen((state) {
      setState(() {
        _loadState = state;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();

    // We only dispose internal controller, external controller will be kept
    if (widget.controller == null) _nativeAdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isAndroid || isiOS) {
      return Container(
        child: _loadState == AdLoadState.loading
            ? _loading
            : _loadState == AdLoadState.loadError
                ? _error
                : _createPlatformView(),
      );
    }

    return Text('$defaultTargetPlatform is not supported PlatformView yet.');
  }

  Widget _createPlatformView() {
    final creationParams = {
      "options": _options.toJson(),
      "controllerID": _nativeAdController.id,
      "type": _type.toString().replaceAll("NativeAdmobType.", ""),
    };

    return isAndroid
        ? AndroidView(
            viewType: _viewType,
            creationParamsCodec: StandardMessageCodec(),
            creationParams: creationParams,
          )
        : UiKitView(
            viewType: _viewType,
            creationParamsCodec: StandardMessageCodec(),
            creationParams: creationParams,
          );
  }
}
