package com.example.blca_project_app

import android.os.Bundle
import android.os.PersistableBundle
import com.google.firebase.FirebaseApp
import com.google.firebase.appcheck.FirebaseAppCheck
import com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory
import io.flutter.embedding.android.FlutterActivity


class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        FirebaseApp.initializeApp( /*context=*/this)
        val firebaseAppCheck = FirebaseAppCheck.getInstance()
        firebaseAppCheck.installAppCheckProviderFactory(
            DebugAppCheckProviderFactory.getInstance())
        super.onCreate(savedInstanceState, persistentState)
    }
}