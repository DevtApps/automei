package com.example.automei


import android.os.Bundle
import com.facebook.FacebookSdk
import com.facebook.FacebookSdk.setAdvertiserIDCollectionEnabled
import com.facebook.FacebookSdk.setAutoLogAppEventsEnabled
import com.facebook.LoggingBehavior
import com.facebook.appevents.AppEventsLogger
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        
        super.onCreate(savedInstanceState)
        FacebookSdk.setAutoInitEnabled(true)
        setAdvertiserIDCollectionEnabled(true)
        FacebookSdk.fullyInitialize()
        setAutoLogAppEventsEnabled(true);

    }
}