import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:himrishtey/screens/banned_user.dart';
import 'package:himrishtey/screens/dashboardScreens/chat.dart';
import 'package:himrishtey/screens/dashboardScreens/home.dart';
import 'package:himrishtey/screens/dashboardScreens/interests.dart';
import 'package:himrishtey/screens/membership/membership_ios.dart';
import 'package:himrishtey/screens/profile_detail.dart';
import 'package:himrishtey/screens/membership/membership.dart';
import 'package:himrishtey/screens/search/quick_searh.dart';
import 'package:himrishtey/screens/userScreens/user_profile.dart';
import 'package:himrishtey/screens/wallet/wallet.dart';
import 'package:himrishtey/screens/wallet/wallet_ios.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/send_analytics.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/activate_plan_widget.dart';
import 'package:himrishtey/widgets/devbhoomi_banner.dart';
import 'package:himrishtey/widgets/loading_image.dart';
import 'package:himrishtey/widgets/no_connection_bottom_bar.dart';
import 'package:himrishtey/widgets/side_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/common.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with Observer {
  int selectedIndex = 0;

  List<Widget> screens = [
    Home(),
    Interests(),
    // Chat(),
    QuickSearch()
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  void initState() {
    // Send stats to firebase and Pixel
    sendStats("app_home");
    Observable.instance.addObserver(this);
    getUserValues();

    Future.delayed(Duration(minutes: 15), () {
      showRatingPopup();
    });

    super.initState();
  }

  showRatingPopup() async {
    final prefs = await SharedPreferences.getInstance();

    bool? popupFlag = prefs.getBool(isRatingAdded);
    String? popupDate = prefs.getString(lastPopupDate);
    var date = DateTime.now().day.toString();
    if (popupFlag.toString() == "null" || !popupFlag!) {
      if (popupDate.toString() == "null" || popupDate != date) {
        showRateUsDialog(context);
        setValue(lastPopupDate, date);
      }
    }
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  bool showPrice = false;

  // membership popup timer
  late Timer _timer;
  int _start = 300;

  @override
  update(Observable observable, String? notifyName, Map? map) {
    if (notifyName == drawer_close) {
      _key.currentState?.closeDrawer();
    }
    if (notifyName == show_price) {
      setState(() {
        showPrice = true;
      });
    }
    if (notifyName == dashboard_tab_changer) {
      setState(() {
        selectedIndex = map!['index'];
      });
      _key.currentState?.closeDrawer();
    }
    if (notifyName == disable_home) {
      setState(() {
        // isPlanActivated = false;
        Navigator.pop(context);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => BannedUser()));
      });
    }
    if (notifyName == show_membership_popup) {
      membershipPopup();
    }
    getUserValues();
    setState(() {});
  }

  membershipPopup() {
    const oneSec = const Duration(seconds: 1);

    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            showDialog<void>(
              context: context,
              barrierDismissible: true, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: white,
                  title: const Text('Membership Plan Inactive'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text('Your membership plan is not active.'),
                        Text(
                            'Click on the button below and activate your membership plan.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Container(
                      decoration: borderRadius(primaryColor, 10),
                      child: TextButton(
                        child: const Text(
                          'Activate',
                          style: TextStyle(color: white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Membership()));
                        },
                      ),
                    ),
                  ],
                );
              },
            );
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            // print(_start.toString());
          });
        }
      },
    );
  }

  DateTime? currentBackPressTime;
  bool canPopNow = false;
  int requiredSeconds = 2;

  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      if (selectedIndex != 0) {
        setState(() {
          selectedIndex = 0;
        });
        return;
      }
      currentBackPressTime = now;
      showToast("Press back to exit.");
      Future.delayed(
        Duration(seconds: requiredSeconds),
        () {
          // Disable pop invoke and close the toast after 2s timeout
          setState(() {
            canPopNow = false;
          });
        },
      );
      // Ok, let user exit app on the next back press
      setState(() {
        canPopNow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        key: _key,
        drawer: SideDrawer(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          backgroundColor: backgroundLight,
          title: Container(
            height: 55,
            decoration: borderRadius(white, 25),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => UserProfile()));
              },
              child: Container(
                color: white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                              onPressed: () {
                                _key.currentState!.openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                size: 22,
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              "Hi, " + nameSaved.toString(),
                              style: TextStyle(
                                  color: textMedium(),
                                  fontSize: 14,
                                  fontFamily: "medium"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        showPrice
                            ? Column(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Platform.isIOS
                                            ? Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        WalletIos()))
                                            : //showContactDialog(context,
                                            //"To get this functionality please contact us.")
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        Wallet()));
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.wallet,
                                            color: textMedium(),
                                            size: 21,
                                          ),
                                          Text(
                                            //  currencySign +
                                            userInfo['wallet_amount'],
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: textDark()),
                                          )
                                        ],
                                      )),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            profileDialog();
                          },
                          child: Container(
                            decoration: borderRadius(white, 25),
                            margin: EdgeInsets.only(right: 8),
                            height: 37,
                            width: 37,
                            clipBehavior: Clip.antiAlias,
                            child: LoadingImage(photoSaved),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        body: isPlanActivated
            ? IndexedStack(
                children: screens,
                index: selectedIndex,
              )
            : Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "Select your membership plan and get your life partner."),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: borderRadius(primaryColor, 10),
                        child: TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Membership()));
                              setState(() {
                                isPlanActivated = true;
                              });
                            },
                            child: Text(
                              "Select Membership",
                              style:
                                  TextStyle(color: white, fontFamily: "medium"),
                            )),
                      )
                    ],
                  ),
                ),
              ),
        bottomNavigationBar: Wrap(
          children: [
            DevbhoomiBanner(),
            NoConnectionBottomBar(),
            NavigationBar(
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              selectedIndex: selectedIndex,
              indicatorColor: primaryColor,
              backgroundColor: white,
              surfaceTintColor: Colors.grey,
              destinations: const <Widget>[
                NavigationDestination(
                  //selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_rounded),
                  label: 'Interests',
                ),
                // NavigationDestination(
                //   // selectedIcon: Icon(Icons.chat),
                //   icon: Icon(Icons.chat),
                //   label: 'Chats',
                // ),
                NavigationDestination(
                  // selectedIcon: Icon(Icons.chat),
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  var nameSaved;
  var emailSaved;
  var profileIdSaved;
  var photoSaved;
  getUserValues() async {
    nameSaved = await getString(key: fullName);
    emailSaved = await getString(key: email);
    profileIdSaved = await getString(key: profileId);
    photoSaved = await getString(key: photo);
    setState(() {});
  }

  profileDialog() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => Dialog(
              elevation: 0,
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: SizedBox(
                height: 480,
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 50, bottom: 30),
                      decoration: borderRadius(lightBackgroundColor(), 20),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.only(right: 8),
                                    height: 45,
                                    width: 45,
                                    child: Stack(
                                      children: [
                                        Container(
                                            height: 45,
                                            width: 45,
                                            decoration: borderRadius(white, 25),
                                            clipBehavior: Clip.antiAlias,
                                            child: LoadingImage(photoSaved)),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration:
                                                borderRadius(textDark(), 10),
                                            child: Icon(
                                              Icons.camera_alt_outlined,
                                              size: 13,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          nameSaved!,
                                          style: TextStyle(
                                              color: textDark(),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          profileIdSaved!,
                                          style: TextStyle(
                                              color: textLightest(),
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      emailSaved!,
                                      style: TextStyle(
                                          color: textMedium(),
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    UserProfile()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0,
                                              color: textLightest()),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0) //
                                              ),
                                        ),
                                        child: Text(
                                          "View Your Profile",
                                          style: TextStyle(
                                              color: textMedium(),
                                              fontSize: 13.5,
                                              fontFamily: "medium"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: dividerColor,
                            height: 40,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                child: Center(
                                    child: Container(
                                        height: 45,
                                        width: 45,
                                        padding: EdgeInsets.all(8),
                                        child: Image.asset(
                                            "assets/images/wallet.png"))),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wallet",
                                      style: TextStyle(
                                          color: textDark(),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 0,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Wallet Balance",
                                          style: TextStyle(
                                              color: textLightest(),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        userInfo == {}
                                            ? Text("")
                                            : Text(
                                                currencySign +
                                                    userInfo['wallet_amount'],
                                                style: TextStyle(
                                                    color: textDark(),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    userInfo == {}
                                        ? Text("")
                                        : GestureDetector(
                                            onTap: () {
                                              Platform.isIOS
                                                  ? Navigator.pushReplacement(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              WalletIos()))
                                                  : Navigator.pushReplacement(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (context) =>
                                                              Wallet()));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 7, vertical: 4),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: textLightest()),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0) //
                                                    ),
                                              ),
                                              child: Text(
                                                "View wallet",
                                                style: TextStyle(
                                                    color: textMedium(),
                                                    fontSize: 13.5,
                                                    fontFamily: "medium"),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: dividerColor,
                            height: 40,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                child: Center(
                                    child: Container(
                                        height: 45,
                                        width: 45,
                                        padding: EdgeInsets.all(8),
                                        child: Image.asset(
                                            "assets/images/plans.png"))),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Membership",
                                          style: TextStyle(
                                              color: textDark(),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        userInfo == {}
                                            ? Text("")
                                            : Text(
                                                userInfo['active'],
                                                style: TextStyle(
                                                    color: userInfo['active'] ==
                                                            "Active"
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Plan name",
                                          style: TextStyle(
                                              color: textLightest(),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        userInfo == {}
                                            ? Text("")
                                            : Text(
                                                userInfo['plan_name']
                                                            .toString() ==
                                                        "null"
                                                    ? "Free"
                                                    : userInfo['plan_name']
                                                        .toString(),
                                                style: TextStyle(
                                                    color: textDark(),
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    Membership()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0,
                                              color: textLightest()),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0) //
                                              ),
                                        ),
                                        child: Text(
                                          "View membership plans",
                                          style: TextStyle(
                                              color: textMedium(),
                                              fontSize: 13.5,
                                              fontFamily: "medium"),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: dividerColor,
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Terms and Conditions",
                                style: TextStyle(
                                    color: textLightest(),
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.circle,
                                size: 4,
                                color: textLightest(),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    color: textLightest(),
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          color: white,
                          margin: EdgeInsets.only(top: 14, right: 20),
                          child: Icon(
                            Icons.close,
                            size: 22,
                            color: textLightest(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
