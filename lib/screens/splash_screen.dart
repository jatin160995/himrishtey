import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/firebase/app_notifications.dart';
import 'package:himrishtey/main.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/screens/intro.dart';
import 'package:himrishtey/utils/default_gradient.dart';

import '../utils/common.dart';
import '../utils/variables/globals.dart' as globals;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2500), () {
      print("Timer");
      setupFirebase();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                globals.isCurrentlyLogin ? Dashboard() : IntroScreen()),
      );
    });
    super.initState();
  }

  setupFirebase() async {
    const FirebaseOptions android = FirebaseOptions(
      apiKey: 'AIzaSyD3TVugxTCsS7SDFk91Qz2GBaAKjqYosyI',
      appId: '1:623038213165:android:a76cb01f31521360dadca4',
      messagingSenderId: '623038213165',
      projectId: 'rishtey-69a89',
      storageBucket: 'rishtey-69a89.appspot.com',
    );

    const FirebaseOptions ios = FirebaseOptions(
      apiKey: 'AIzaSyDio3bWpnXIXnjcUHU-muElcrP8p2pNu7o',
      appId: '1:623038213165:ios:77ab0d0f8efabb34dadca4',
      messagingSenderId: '623038213165',
      projectId: 'rishtey-69a89',
      storageBucket: 'rishtey-69a89.appspot.com',
      androidClientId:
          '623038213165-d4p225bg8k8ged36drj6ocf75lfcsv76.apps.googleusercontent.com',
      iosClientId:
          '623038213165-r033da0cls2s9avje41hfaliu4mkf1ad.apps.googleusercontent.com',
      iosBundleId: 'com.app.himrishtey',
    );
    await Firebase.initializeApp();
    // options: Platform.isAndroid ? android : ios, name: "HimRishtey");
    FirebaseMessaging.onBackgroundMessage(
        AppNotificationHandler.firebaseMessagingBackgroundHandler);
    // You may set the permission requests to "provisional" which allows the user to choose what type
// of notifications they would like to receive once the user receives a notification.
//     final notificationSettings =
//         await FirebaseMessaging.instance.requestPermission(provisional: true);

// // For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
//     final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//     print("Token -- " + apnsToken.toString());
//     if (apnsToken != null) {
//       // APNS token is available, make FCM plugin API requests...
//     }
    AppNotificationHandler.getFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: defaultGradient(),
        child: Center(
          child: Container(
              margin: EdgeInsets.all(40),
              child: Image.asset(globals.isHimrishtey == 1
                  ? logo_white
                  : globals.isHimrishtey == 2
                      ? "assets/images/logo-white-dev.png"
                      : "assets/images/dogri-rishtey-white.png")),
        ),
      ),
    );
  }
}
