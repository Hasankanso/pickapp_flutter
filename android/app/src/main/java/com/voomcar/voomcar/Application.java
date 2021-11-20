package com.voomcar.voomcar;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Build;

import androidx.annotation.RequiresApi;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
//import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
//import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;
import io.flutter.plugins.pathprovider.PathProviderPlugin;

import com.adcolony.sdk.AdColonyAppOptions;
import com.voomcar.voomcar.R;
import com.whelksoft.flutter_native_timezone.FlutterNativeTimezonePlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.google.ads.mediation.adcolony.AdColonyMediationAdapter;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    public void onCreate() {
        super.onCreate();
        this.createChannel();
        AdColonyAppOptions appOptions = AdColonyMediationAdapter.getAppOptions();
        appOptions.setPrivacyFrameworkRequired(AdColonyAppOptions.GDPR, true);
        appOptions.setPrivacyConsentString(AdColonyAppOptions.GDPR, "1");
        //FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        //FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
        FlutterNativeTimezonePlugin.registerWith(registry.registrarFor("com.whelksoft.flutter_native_timezone.FlutterNativeTimezonePlugin"));
        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    private void createChannel(){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Create the NotificationChannel
            String name = getString(R.string.default_notification_channel_id);
            NotificationChannel channel = new NotificationChannel(name, "default", NotificationManager.IMPORTANCE_HIGH);
            NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            notificationManager.createNotificationChannel(channel);
        }
    }
}
