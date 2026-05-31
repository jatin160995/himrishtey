import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/auth/profile/change_password.dart';
import 'package:himrishtey/screens/auth/profile/delete_profile.dart';
import 'package:himrishtey/screens/auth/profile/hide_profile.dart';
import 'package:himrishtey/screens/membership/in_app_purchase_custom.dart';
import 'package:himrishtey/screens/membership/membership_ios.dart';
import 'package:himrishtey/screens/profile_detail.dart';
import 'package:himrishtey/screens/search/advance_search.dart';
import 'package:himrishtey/screens/search/quick_searh.dart';
import 'package:himrishtey/screens/search/search_profile_by_id.dart';
import 'package:himrishtey/screens/membership/membership.dart';
import 'package:himrishtey/screens/sideMenuScreens/privacy_policies.dart';
import 'package:himrishtey/screens/sideMenuScreens/refund_policy.dart';
import 'package:himrishtey/screens/sideMenuScreens/termsAndConditons.dart';
import 'package:himrishtey/screens/successStories/success_stories.dart';
import 'package:himrishtey/screens/userScreens/view_my_profile.dart';
import 'package:himrishtey/screens/viewed_contacts.dart';
import 'package:himrishtey/screens/webview_screen.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/gradient_text.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
//import 'package:url_launcher/url_launcher.dart';

import '../screens/userScreens/user_profile.dart';
import '../utils/container_radius.dart';
import 'loading_image.dart';
import '../utils/variables/globals.dart' as globals;

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  String nameSaved = "";
  String emailSaved = "";
  String profileIdSaved = "";
  var photoSaved;
  getUserValues() async {
    nameSaved = (await getString(key: fullName))!;
    emailSaved = (await getString(key: email))!;
    profileIdSaved = (await getString(key: profileId))!;
    photoSaved = await getString(key: photo);
    setState(() {});
  }

  @override
  void initState() {
    getUserValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: double.infinity,
      color: Colors.white,
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (context) => UserProfile()));
            },
            child: Container(
              //height: 190,
              color: lightBackgroundColor(),
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      decoration: borderRadius(white, 40),
                      margin: EdgeInsets.only(right: 8),
                      height: 80,
                      width: 80,
                      clipBehavior: Clip.antiAlias,
                      child: LoadingImage(photoSaved)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading(nameSaved),
                        Text(
                          "Profile Id",
                          style: TextStyle(color: textLightest(), fontSize: 11),
                        ),
                        Text(
                          profileIdSaved,
                          style: TextStyle(
                              color: textMedium(),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Membership",
                              style: TextStyle(
                                  color: textLightest(), fontSize: 11),
                            ),
                            userInfo == {}
                                ? Text("")
                                : Text(
                                    userInfo['active'],
                                    style: TextStyle(
                                        color: userInfo['active'] == "Active"
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                            SizedBox(height: 5),
                            Text(
                              "Plan name",
                              style: TextStyle(
                                  color: textLightest(),
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal),
                            ),
                            userInfo == {}
                                ? Text("")
                                : GradientText(
                                    userInfo['plan_name'].toString() == "null"
                                        ? "Free"
                                        : userInfo['plan_name'].toString(),
                                    style: const TextStyle(
                                        fontSize: 16, fontFamily: "medium"),
                                    gradient: LinearGradient(colors: [
                                      const Color(0xFFB78628),
                                      const Color(0xFFFCC201),
                                    ]),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Menu",
                  style: TextStyle(
                      color: textLightest(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                    onTap: () {
                      Observable.instance.notifyObservers(
                          [
                            dashboard_observer,
                          ],
                          notifyName: dashboard_tab_changer,
                          map: {'index': 0});
                    },
                    child: optionWidget(Icons.home_outlined, "Home")),
                GestureDetector(
                    onTap: () {
                      // Platform.isIOS
                      //     ? Navigator.push(
                      //         context,
                      //         CupertinoPageRoute(
                      //             builder: (context) =>
                      //                 MyApp())) // InAppPurchaseCustom()))
                      //     :
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Membership()));
                    },
                    child: optionWidget(Icons.shield_outlined, "Membership")),
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => UserProfile())),
                    child: optionWidget(Icons.edit_outlined, "Edit Profile")),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => QuickSearch()));
                    },
                    child: optionWidget(Icons.search, "Quick Search")),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => AdvanceSearch()));
                    },
                    child: optionWidget(
                        Icons.saved_search_rounded, "Advanced Search")),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => SearchProfileById()));
                  },
                  child: optionWidget(
                      Icons.person_search_rounded, "Search by Profile id"),
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
                    child: optionWidget(
                        Icons.account_box_outlined, "Interest Box")),
                // optionWidget(Icons.people_outline, "Matching Profiles"),
                // optionWidget(
                //     Icons.co_present_outlined, "Short listed Profiles"),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ViewMyProfile()));
                    },
                    child: optionWidget(
                        Icons.password_rounded, "View My Profile")),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ChangePassword()));
                    },
                    child: optionWidget(
                        Icons.password_rounded, "Change Password")),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ViewedContacts(
                                  "Viewed Contact", viewed_profile_url)));
                    },
                    child: optionWidget(
                        Icons.contact_phone_outlined, "Viewed Contact")),
                GestureDetector(
                  onTap: () {
                    showWarningDialog(context, "Feature coming soon");
                  },
                  child: optionWidget(
                      Icons.send_time_extension_outlined, "Refer & Earn"),
                ),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => SuccessStories()));
                    },
                    child: optionWidget(
                        Icons.military_tech_rounded, "Success Stories")),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         CupertinoPageRoute(
                //             builder: (context) => HideProfile()));
                //   },
                //   child:
                //       optionWidget(Icons.person_off_outlined, "Hide Profile"),
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => DeleteProfile()));
                  },
                  child: optionWidget(
                      Icons.person_remove_alt_1_outlined, "Delete Profile"),
                ),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => RefundPolicy()));
                    },
                    child: optionWidget(
                        Icons.report_off_rounded, "Refund & Cancellation")),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => WebviewScreen(
                      //             "Privacy Policy",
                      //             "https://himrishtey.com/privacy_policy.php")));
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => PrivacyPolicy()));
                    },
                    child: optionWidget(
                        Icons.privacy_tip_outlined, "Privacy Policy")),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      showRateUsDialog(context);
                    },
                    child: optionWidget(
                        Icons.star_border_purple500_rounded, "Rate us")),
                GestureDetector(
                    onTap: () async {
                      // if (!await launchUrl(Uri.parse("tel:9857102002"))) {
                      //   // throw Exception('Could not launch $_url');
                      // }
                    },
                    child: optionWidget(Icons.sos, "Helpline-9857102002")),
                GestureDetector(
                    onTap: () {
                      closeDrawer();
                      // Navigator.push(
                      //     context,
                      //     CupertinoPageRoute(
                      //         builder: (context) => WebviewScreen(
                      //             "Terms & conditions",
                      //             "https://himrishtey.com/terms_and_conditions.php")));
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => TermsAndConditions()));
                    },
                    child: optionWidget(
                        Icons.list_alt_outlined, "Terms & conditions")),
                GestureDetector(
                    onTap: () {
                      logoutDialog();
                    },
                    child: optionWidget(Icons.logout_rounded, "Logout"))
              ],
            ),
          )
        ],
      ),
    );
  }

  closeDrawer() {
    Observable.instance.notifyObservers(
        [
          dashboard_observer,
        ],
        notifyName: drawer_close,
        map: {});
  }

  Widget optionWidget(
    IconData icon,
    String title,
  ) {
    return Container(
      // /height: 50,
      child: Column(
        children: [
          Divider(
            height: 30,
            color: backgroundLight,
          ),
          Row(
            children: [
              Icon(
                icon,
                color: textLightest(),
                size: 22,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: TextStyle(
                    color: textDark(), fontSize: 15, fontFamily: "medium"),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> logoutDialog() async {
    return showDialog<void>(
      context: context,

      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          title: const Text('Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: textDark(),
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Auth().logout();
                Navigator.of(context).popUntil(ModalRoute.withName('/login'));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
