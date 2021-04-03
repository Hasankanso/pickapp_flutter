package com.example.pickapp;

import io.flutter.embedding.android.FlutterActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin;





public class MainActivity extends FlutterActivity {


    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        flutterEngine.getPlugins().add(new GoogleMobileAdsPlugin());
        super.configureFlutterEngine(flutterEngine);

        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "adFactoryID", NativeAdFactoryExample());
    }

    @Override
    public void cleanUpFlutterEngine(FlutterEngine flutterEngine) {
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "adFactoryID");
    }

}




