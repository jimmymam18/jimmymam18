package com.appacore.bizitme

import io.flutter.embedding.android.FlutterActivity

import io.flutter.app.FlutterApplication

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import androidx.annotation.NonNull


class MainActivity: FlutterActivity(){

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {

//            val soundUri: Uri = Uri.parse(
//                    "android.resource://" +
//                            applicationContext.packageName +
//                            "/" +
//                            com.spoke.spokeapp.R.raw.alarm)
            val soundUri = Uri.parse( "android.resource://" + getApplicationContext().getPackageName() + "/" + R.raw.alarm);
            val audioAttributes = AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build()

            val channel = NotificationChannel("noti_push_app_1",
                    "noti_push_app_1",
                    NotificationManager.IMPORTANCE_HIGH)
            channel.setSound(soundUri, audioAttributes)

            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                    .createNotificationChannel(channel)
        }
    }
}