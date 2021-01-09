package com.example.pickapp;

import com.backendless.push.BackendlessFCMService;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class PickAppFCMService extends BackendlessFCMService {
    private static final String TAG = BackendlessFCMService.class.getSimpleName();

    @Override
    public boolean onMessage(Context appContext, Intent msgIntent) {
        String action=msgIntent.getStringExtra("action");
        if(action.equals("alert")){
            Log.i( TAG,"this is an alert");
        }
        return true;
    }
}