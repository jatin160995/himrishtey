import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/editAstro.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_contact.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_education.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_family.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_lifestyle.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_preferences.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_religion.dart';
import 'package:himrishtey/screens/auth/profile/edit_info.dart';
import 'package:himrishtey/screens/userScreens/user_profile.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/widgets/circular_progress_bar.dart';

class ProfileCompletionStatus extends StatefulWidget {
  dynamic data;
  ProfileCompletionStatus(this.data, {super.key});

  @override
  State<ProfileCompletionStatus> createState() =>
      _ProfileCompletionStatusState();
}

class _ProfileCompletionStatusState extends State<ProfileCompletionStatus> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      decoration: borderRadius(lightBackgroundColor(), 8),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        heading("Complete your profile"),
                        Text(
                          "Add your complete information to get more response",
                          style: TextStyle(color: textLightest(), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: 80,
                        width: 80,
                        child: CircularProgress(widget.data)),
                    Text(
                      "Profile Score",
                      style: TextStyle(
                          color: textDark(),
                          fontSize: 11,
                          fontFamily: "medium"),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 0,
          ),
          Container(
            height: 100,
            margin: EdgeInsets.only(bottom: 15),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(context,
                          CupertinoPageRoute(builder: (context) => EditInfo()));
                      profileRequest();
                    },
                    child: sectionCell("Basic Info", "Describe yourself",
                        Colors.indigo, "assets/images/about.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditReligion()));
                      profileRequest();
                    },
                    child: sectionCell(
                        "Religion",
                        "Describe your religious preferences",
                        Colors.orange,
                        "assets/images/religion.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditAstro()));
                      profileRequest();
                    },
                    child: sectionCell(
                        "Kundli",
                        "Fillup your birth and kundli details",
                        Colors.blue,
                        "assets/images/horoscope.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditContact()));
                      profileRequest();
                    },
                    child: sectionCell("Contact", "Fillup your contact details",
                        Colors.deepOrange, "assets/images/contact.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditEducation()));
                      profileRequest();
                    },
                    child: sectionCell("Education", "Fillup your Educations",
                        Colors.green, "assets/images/education.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditFamily()));
                      profileRequest();
                    },
                    child: sectionCell("Family", "Tell us about your Family",
                        Colors.purple, "assets/images/family.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditLifestyle()));
                      profileRequest();
                    },
                    child: sectionCell("Lifestyle", "Describe your lifestyle",
                        Colors.pink, "assets/images/lifestyle.png")),
                GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => EditPreference()));
                      profileRequest();
                    },
                    child: sectionCell(
                        "Partner",
                        "Describe your partner preferences",
                        Colors.amber,
                        "assets/images/partner.png")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  sectionCell(String title, String text, Color color, String icon) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 100,
      width: 150,
      decoration: borderRadius(white, 8),
      margin: EdgeInsets.only(right: 15),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: textDark(),
                          fontSize: 15,
                          fontFamily: "medium"),
                    ),
                  ),
                ],
              ),
              Text(
                text,
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: textLightest(),
                    fontSize: 11.4,
                    fontFamily: "medium"),
              )
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              icon,
              height: 30,
              width: 30,
              color: color,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 5,
              color: color,
            ),
          )
        ],
      ),
    );
  }

  Auth auth = new Auth();

  profileRequest() async {
    dynamic responseData = await auth.getProfile();

    if (responseData['success']) {
      userInfo = responseData['data']['user'];
      userImages = responseData['images'];

      Observable.instance.notifyObservers([
        dashboard_observer,
      ],
          //notifyName: disable_home,
          map: {});
      List imgArr = [];
      for (int i = 0; i < userImages.length; i++) {
        imgArr.add(userImages[i]['images']);
      }
      print(userInfo);
    }
  }
}
