import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/firebase/app_notifications.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/screens/membership/membership.dart';
import 'package:himrishtey/screens/splash_screen.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:himrishtey/utils/variables/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// ✅ Step 1: Initialize Firebase
  await Firebase.initializeApp();

  // ✅ Step 2: Register background handler BEFORE runApp
  FirebaseMessaging.onBackgroundMessage(
    AppNotificationHandler.firebaseMessagingBackgroundHandler,
  );

  // ✅ Step 3: Initialize local notifications
  await AppNotificationHandler.initLocalNotifications();

  // ✅ Step 4: Request permission
  await AppNotificationHandler.requestPermission();
  runApp(MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with Observer {
  var listener;

  checkIfLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? doLogout = prefs.getInt("doLogout1");
    print(doLogout.toString() + "---doLogout");
    if (doLogout.toString() == "null") {
      prefs.setBool(isLoggedIn, false);
      prefs.setInt("doLogout1", 1);
    }

    bool? loginFlag = prefs.getBool(isLoggedIn);
    globals.isHimrishtey = prefs.getInt(isHimrishteyShared).toString() == "null"
        ? 1
        : prefs.getInt(isHimrishteyShared);

    if (loginFlag.toString() == "null" || !loginFlag!) {
      setState(() {
        globals.isCurrentlyLogin = false;
      });
    } else {
      globals.userFullName = prefs.getString(fullName)!;
      globals.profilePhoto = prefs.getString(photo)!;
      if (!globals.isCurrentlyLogin) {
        setState(() {
          globals.isCurrentlyLogin = true;
        });
      }
    }
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {}

  @override
  void initState() {
    Observable.instance.addObserver(this);
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    checkIfLogin();
    //  Wire up all notification listeners
    AppNotificationHandler.showMsgHandler();
    AppNotificationHandler.getInitialMsg();
    AppNotificationHandler.onMsgOpen();
    AppNotificationHandler.getFcmToken();

    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          setState(() {
            isConnected = true;
          });
          print('Data connection is available.');
          break;
        case InternetConnectionStatus.disconnected:
          setState(() {
            isConnected = false;
          });
          print('You are disconnected from the internet.');
          break;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        ),
      ],
      child: Container(
          child: MaterialApp(
        routes: {
          "/login": (context) => Login(),
          "/membership": (context) => Membership(),
          "/dashboard": (context) => Dashboard(),
        },
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          iconTheme: IconThemeData(color: white),
          useMaterial3: true,
          brightness: Brightness.light,
          fontFamily: 'poppins',
          primaryColor: primaryColor,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: primaryColor),
        ),
      )),
    );
  }
}
