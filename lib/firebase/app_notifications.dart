import 'dart:convert';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';

class AppNotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel 2', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('notification'),
  );

  ///get fcm token
  static Future<String> getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    try {
      String? token = await firebaseMessaging.getToken();
      // await PreferenceManager.setFCMToken(token);
      log("=========fcm-token===$token");
      setValue("fcmToken", token!);
      return token!;
    } catch (e) {
      log("=========fcm- Error :$e");
      return "";
    }
  }

  ///call when app in fore ground
  static void showMsgHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        print("duiodhjiop");
        showMsg(notification);
      }
    });
  }

  /// handle notification when app in fore ground..
  static void getInitialMsg() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      print("recieved for $message");
      print(message!.notification!.title.toString());
      showMsg(message.notification!);
    });
  }

  static void onMsgOpen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMsgOpen A new onMessageOpenedApp event was published!');
      if (message != null) {
        print(message.notification?.body);
      }
    });
  }

  ///show notification msg
  static void showMsg(RemoteNotification notification) {
    print("notification --- ${notification.body}");
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel 2', // id
            'High Importance Notifications', // title
            channelDescription:
                'This channel is used for important notifications.',
            // description
            importance: Importance.max,
            //sound: RawResourceAndroidNotificationSound('notification'),
// icon: "assets/nostar_icon.png"
          ),
        ));
  }

  ///background notification handler..
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
    showMsg(message.notification!);
  }
}
