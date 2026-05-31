import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/home_controller.dart';
import 'package:himrishtey/screens/all_profiles.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/auth/otp_login.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/horizontal_home_grid.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';
import 'package:himrishtey/widgets/profile_completion_status.dart';
import 'package:himrishtey/widgets/verify_profile_warn.dart';
import 'package:package_info_plus/package_info_plus.dart';
//import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Observer {
  @override
  void initState() {
    Observable.instance.addObserver(this);
    profileRequest();
    statsRequest();
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    profileRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor(),
      child: ListView(
        //padding: EdgeInsets.all(20),

        children: [
          Column(
            children: [
              isLoading
                  ? Loader()
                  : Column(
                      children: [
                        isStatsLoading ? Loader() : dashBlocks(),
                        userInfo['mem_type'] == "Verified"
                            ? Container()
                            : GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpLogin(2)),
                                  );
                                  profileRequest();
                                  statsRequest();
                                },
                                child: VerifyProfileWarn()),
                        userInfo['profile_completed'] == "100"
                            ? Container()
                            : ProfileCompletionStatus(
                                userInfo['profile_completed']),
                      ],
                    ),
              HorizontalHomeGrid("Recent Profiles", recent_profile_url),
              SizedBox(
                height: 20,
              ),
              HorizontalHomeGrid("Matching Profiles", matching_profiles_url),
              SizedBox(
                height: 20,
              ),
              HorizontalHomeGrid("Verified Profiles", verified_profiles_url),
              SizedBox(
                height: 20,
              ),
              HorizontalHomeGrid(
                  "Who viewed my profile", who_viewed_profile_url),
              SizedBox(
                height: 20,
              ),
              HorizontalHomeGrid(
                  "Shortlisted Profiles", shortlisted_profiles_url),
              SizedBox(
                height: 20,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget dashBlocks() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllProfiles(1)),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: borderRadius(Colors.pink[100]!, 10),
              height: 100,
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile visits",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "medium",
                        color: textMedium()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statsData['profile_viewed'].toString(),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        "assets/images/profile.png",
                        height: 40,
                        width: 40,
                        color: Colors.pink,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllProfiles(0)),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: borderRadius(Colors.blue[100]!, 10),
              height: 100,
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Likes",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "medium",
                        color: textMedium()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statsData['profile_likes'].toString(),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        "assets/images/like.png",
                        height: 40,
                        width: 40,
                        color: Colors.blue,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Observable.instance.notifyObservers(
                  [
                    dashboard_observer,
                  ],
                  notifyName: dashboard_tab_changer,
                  map: {'index': 1});
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: borderRadius(Colors.purple[100]!, 10),
              height: 100,
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Interests",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "medium",
                        color: textMedium()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statsData['recieved_interest'].toString(),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        "assets/images/user-plus.png",
                        height: 40,
                        width: 40,
                        color: Colors.purple,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllProfiles(2)),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: borderRadius(Colors.green[100]!, 10),
              height: 100,
              width: (MediaQuery.of(context).size.width - 60) / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Viewed",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: "medium",
                        color: textMedium()),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        statsData['contact_viewed'].toString(),
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      Image.asset(
                        "assets/images/request.png",
                        height: 40,
                        width: 40,
                        color: Colors.green,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Auth auth = new Auth();
  bool isLoading = true;
  profileRequest() async {
    dynamic responseData = await auth.getProfile();
    loadingState(true);
    print(responseData['active']);
    if (responseData['success']) {
      userInfo = responseData['data']['user'];
      print(userInfo['active']);
      if (userInfo['active'] == 'Deleted' || userInfo['active'] == 'Banned') {
        Auth().logout();
        Navigator.of(context).popUntil(ModalRoute.withName('/login'));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        showToast(
            "Your profile has been deleted. Please contant support team for assistance.");
      }

      userImages = responseData['images'];
      //saving Data

      print(userInfo);
      loadingState(false);
      if (userInfo['active'] == "Banned") {
        Observable.instance.notifyObservers(
            [
              dashboard_observer,
            ],
            notifyName: disable_home,
            map: {});
      }
      if (userInfo["plan_activated"] == 'No') {
        Observable.instance.notifyObservers(
            [
              dashboard_observer,
            ],
            notifyName: show_membership_popup,
            map: {});
      }
      Observable.instance.notifyObservers(
          [
            dashboard_observer,
          ],
          notifyName: show_price,
          map: {});
      //dynamic data = responseData['user'];
      setValue(photo, userInfo['photo']);
    } else {
      loadingState(false);
      showToast(
          "Username or password wrong. Please check you credentials and try again");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  bool isStatsLoading = true;
  dynamic statsData;
  statsRequest() async {
    loadingStatsState(true);
    dynamic responseData = await auth.getStats();
    configsRequest();
    if (responseData['success']) {
      statsData = responseData['stats'];
      print(statsData.toString() + "----");
      loadingStatsState(false);
    } else {
      print(statsData.toString() + "----");
      loadingStatsState(false);
      showToast("Error getting stats from server. Please try again later.");
    }
  }

  loadingStatsState(bool state) {
    setState(() {
      isStatsLoading = state;
    });
  }

  configsRequest() async {
    print("start--configs");
    dynamic responseData = await auth.getConfigs();
    if (responseData['success']) {
      dynamic configData = responseData['version'][0];
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String version = packageInfo.version;
      if (version != configData['version'].toString()) {
        if (Platform.isAndroid) {
          updateDialog();
        }
      }
    } else {
      //showToast("Error getting stats from server. Please try again later.");
    }
  }

  updateDialog() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 200,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'New version available. ',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark()),
                  ),
                  Text(
                    'New version of the HimRishtey app is available. You can download the new version by clicking the button below.',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: textLightest()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: borderRadius(primaryColor, 10),
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          if (Platform.isAndroid || Platform.isIOS) {
                            final appId = Platform.isAndroid
                                ? 'com.app.himrishtey'
                                : 'com.app.himrishtey';
                            final url = Uri.parse(
                              Platform.isAndroid
                                  ? "market://details?id=$appId"
                                  : "https://apps.apple.com/app/id$appId",
                            );
                            Navigator.pop(context);
                            // launchUrl(
                            //   url,
                            //   mode: LaunchMode.externalApplication,
                            // );
                          }
                        },
                        child: Text(
                          'Update Now',
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
  }
}
