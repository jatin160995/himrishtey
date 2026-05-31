import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/editAstro.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_contact.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_education.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_family.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_lifestyle.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_preferences.dart';
import 'package:himrishtey/screens/auth/profile/editProfile/edit_religion.dart';
import 'package:himrishtey/screens/auth/profile/edit_info.dart';
import 'package:himrishtey/screens/gallery.dart';
import 'package:himrishtey/screens/userScreens/edit_image.dart';
import 'package:himrishtey/screens/userScreens/upload_profile_photo.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/title_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
//import 'package:url_launcher/url_launcher.dart';

import '../../utils/container_radius.dart';
import '../../utils/gradient_text.dart';
import '../../widgets/loading_image.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<bool> switchStatus = [true, false];
  final ScrollController _controller = ScrollController();

  takePhoto() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 400,
      imageQuality: 90,
    );
    if (image != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadProfilePhoto(image, true)),
      );
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ImageEditorPage()),
      // );
      setState(() {});
    }
    print(image?.path);
    // return image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Profile"),
        actions: [
          TextButton(
              onPressed: () {
                List imgArr = [];
                for (int i = 0; i < userImages.length; i++) {
                  imgArr.add(userImages[i]['images']);
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Gallery(imgArr, userInfo, true)),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.image,
                    color: textDark(),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Gallery",
                    style: TextStyle(color: textMedium()),
                  ),
                ],
              ))
        ],
      ),
      body: isLoading
          ? Center(
              child: Loader(),
            )
          : ListView(
              controller: _controller,
              padding: EdgeInsets.all(20),
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                takePhoto();
                              },
                              child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: borderRadius(white, 45),
                                  clipBehavior: Clip.antiAlias,
                                  child: LoadingImage(userInfo['photo'])),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: borderRadius(textDark(), 10),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userInfo['full_name'],
                              style: TextStyle(
                                  color: textDark(),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              userInfo['profile_id'],
                              style: TextStyle(
                                  color: textMedium(),
                                  fontSize: 16,
                                  fontFamily: "medium"),
                            ),
                            Text(
                              userInfo['email'],
                              style: TextStyle(
                                  color: textMedium(),
                                  fontSize: 16,
                                  fontFamily: "medium"),
                            ),
                            GradientText(
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
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: borderRadius(backgroundLight, 8),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heading("Relationship Manager"),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.contact_emergency_rounded,
                            color: Colors.blue,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Name : " +
                                  (userInfo['relationship_manager'] != ''
                                      ? userInfo['relationship_manager']
                                      : "N/A"),
                              style: TextStyle(
                                  color: textMedium(),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      userInfo['relationship_manager_number'] != ''
                          ? Row(
                              children: [
                                Icon(
                                  Icons.contact_phone,
                                  color: primaryColorLight,
                                  size: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _launchUrl(Uri.parse("tel:" +
                                        userInfo[
                                            'relationship_manager_number']));
                                  },
                                  child: Text(
                                    "Contact : " +
                                        userInfo['relationship_manager_number'],
                                    style: TextStyle(
                                        color: textMedium(),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
                Divider(
                  height: 40,
                  color: dividerColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      isSelected: switchStatus,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedColor: primaryColor,
                      selectedBorderColor: primaryColor,
                      fillColor: primaryAccent,
                      onPressed: (int index) {
                        setState(() {
                          switchStatus.setAll(0, [false, false]);
                          switchStatus[index] = true;
                        });
                      },
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "About Me",
                            style:
                                TextStyle(fontSize: 15, fontFamily: "medium"),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            "Partner Preferences",
                            style:
                                TextStyle(fontSize: 15, fontFamily: "medium"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                switchStatus[0]
                    ? Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            basicInfoSection(),
                            kundliSection(),
                            contactDetailSection(),
                            religionDetailSection(),
                            familyDetail(),
                            lifestyleDetail(),
                            eduDetailSection(),
                          ],
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [partnerPrefs()],
                        ),
                      )
              ],
            ),
    );
  }

  Future<void> _launchUrl(_url) async {
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }

  partnerPrefs() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      //margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Partner Preferences"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditPreference()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 8),
          TitleText("About my partner", userInfo['about_my_partner']),
          SizedBox(height: 8),
          TitleText(
              "Height",
              userInfo['partner_height_from'] +
                  "-" +
                  userInfo['partner_height_to']),
          SizedBox(height: 10),
          TitleText("Age",
              userInfo['partner_age_from'] + "-" + userInfo['partner_age_to']),
          SizedBox(height: 10),
          TitleText("Marital status", userInfo['looking_for']),
          SizedBox(height: 10),
          TitleText(
              "Religion & Mother tongue",
              userInfo['partner_mothertongue'] +
                  " | " +
                  userInfo['partner_religion']),
          SizedBox(height: 10),
          TitleText("Community", userInfo['partner_cast']),
          SizedBox(height: 10),
          TitleText(
              "Is Manglik",
              userInfo['is_partner_manglik'] == ""
                  ? "No"
                  : userInfo['is_partner_manglik']),
          SizedBox(height: 10),
          TitleText("Highest Qualification", userInfo['partner_education']),
          SizedBox(height: 10),
          TitleText(
              "Employed in",
              userInfo['partner_occupation'] == ""
                  ? "N/A"
                  : userInfo['partner_occupation']),
          SizedBox(height: 10),
          TitleText(
              "Annual Income",
              userInfo['partner_annual_income_from'] +
                  "-" +
                  userInfo['partner_annual_income_to']),
          // SizedBox(height: 10),
          // TitleText("Occupation", userInfo['partner_occupation']),
          // SizedBox(height: 10),
          // TitleText("Employed in", userInfo['partner_occupation']),
          SizedBox(height: 10),
          TitleText("Diet", userInfo['partner_diet']),
          SizedBox(height: 10),
          TitleText("Drinking", userInfo['is_partner_drinking']),
          SizedBox(height: 10),
          TitleText("Smoking", userInfo['is_partner_smoking']),
        ],
      ),
    );
  }

  familyDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Family Details"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditFamily()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 8),
          TitleText("About my Family", userInfo['about_family']),
          SizedBox(height: 8),
          TitleText("Family type", userInfo['family_status']),
          SizedBox(height: 10),
          TitleText("Native Place", userInfo['native_place']),
          SizedBox(height: 10),
          TitleText("Father Name", userInfo['father_name']),
          SizedBox(height: 10),
          TitleText("Father Occupation", userInfo['father_occupation']),
          SizedBox(height: 10),
          TitleText("Mother Name", userInfo['mother_name']),
          SizedBox(height: 10),
          TitleText("Mother Occupation", userInfo['mother_occupation']),
          SizedBox(height: 10),
          TitleText("Brother", userInfo['no_of_brothers']),
          SizedBox(height: 10),
          TitleText("Married Brother", userInfo['married_brothers']),
          SizedBox(height: 10),
          TitleText("Sisters", userInfo['no_of_sisters']),
          SizedBox(height: 10),
          TitleText("Married Sisters", userInfo['married_sisters']),
        ],
      ),
    );
  }

  lifestyleDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Lifestyle"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditLifestyle()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 8),
          TitleText("Diet", userInfo['diet'] == "" ? "N/A" : userInfo['diet']),
          SizedBox(height: 10),
          TitleText("Smoking",
              userInfo['is_smoking'] == "" ? "N/A" : userInfo['is_smoking']),
          SizedBox(height: 10),
          TitleText("Drinking",
              userInfo['is_drinking'] == "" ? "N/A" : userInfo['is_drinking']),
          SizedBox(height: 10),
          TitleText(
              "Any disabilty",
              userInfo['any_disability'] == ""
                  ? "No"
                  : userInfo['any_disability']),
        ],
      ),
    );
  }

  basicInfoSection() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      width: double.infinity,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Basic Info"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditInfo()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 8),
          Text(
            userInfo['about_me'] == "" ? "N/A" : userInfo['about_me'],
            style: TextStyle(color: textMedium(), fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            "Created by " +
                userInfo['profile_created_for'] +
                " | " +
                calculateAge(userInfo['birth_date_time']) +
                " years | " +
                userInfo['height'] +
                " ft | Profile id - " +
                userInfo['profile_id'] +
                " | " +
                userInfo['religion'] +
                " | " +
                userInfo['cast'] +
                " | " +
                userInfo['city_living_in'] +
                " | " +
                userInfo['marital_status'],
            style: TextStyle(color: textMedium(), fontSize: 14),
          ),
        ],
      ),
    );
  }

  kundliSection() {
    return Container(
      width: double.infinity,
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Astro and Kundli details"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditAstro()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 10),
          TitleText("Date of birth", readableDate(userInfo['birth_date_time'])),
          SizedBox(height: 10),
          TitleText(
              "Time of birth  ", readableTime(userInfo['birth_date_time'])),
          SizedBox(height: 10),
          TitleText("Place of birth", userInfo['birth_place']),
          SizedBox(height: 10),
          TitleText("Manglik", userInfo['manglik']),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  contactDetailSection() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Contact details"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditContact()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 10),
          TitleText("Contact number", userInfo['mobile_number']),
          SizedBox(height: 10),
          TitleText("Alternate Contact number", userInfo['alternate_number']),
          SizedBox(height: 10),
          TitleText("Whatsapp number", userInfo['whatsapp_number']),
          SizedBox(height: 10),
          TitleText("Email id", userInfo['email']),
        ],
      ),
    );
  }

  religionDetailSection() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Religion Information"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditReligion()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 8),
          TitleText("Community", userInfo['cast']),
          SizedBox(height: 10),
          TitleText("Sub Community",
              userInfo['sub_cast'] == "" ? "N/A" : userInfo['sub_cast']),
          SizedBox(height: 10),
          TitleText("Gotra", userInfo['gotra']),
        ],
      ),
    );
  }

  eduDetailSection() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              heading("Education & Career"),
              Container(
                  height: 35,
                  child: TextButton(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditEducation()),
                        );
                        profileRequest();
                      },
                      child: Text("Edit",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"))))
            ],
          ),
          SizedBox(height: 8),
          TitleText(
              "About my career and education", userInfo['about_my_education']),
          SizedBox(height: 8),
          TitleText("Education", userInfo['education']),
          SizedBox(height: 10),
          TitleText(
              "Other qualification",
              userInfo['any_other_qualifications'] == ""
                  ? "N/A"
                  : userInfo['any_other_qualifications']),
          SizedBox(height: 10),
          TitleText("Employed in", userInfo['employed_in']),
          SizedBox(height: 10),
          TitleText("Occupation", userInfo['occupation']),
          SizedBox(height: 10),
          TitleText("Job Location", userInfo['job_location']),
          SizedBox(height: 10),
          TitleText("Currently working", userInfo['organization_name']),
          SizedBox(height: 10),
          TitleText("Annual income", userInfo['annual_income']),
        ],
      ),
    );
  }

  Auth auth = new Auth();
  bool isLoading = false;
  profileRequest() async {
    loadingState(true);
    dynamic responseData = await auth.getProfile();

    if (responseData['success']) {
      setState(() {
        userInfo = responseData['data']['user'];
        userImages = responseData['images'];
      });
      print(userInfo);
      loadingState(false);
    } else {
      loadingState(false);
      showToast(
          "Username or password wrong. Please check you credentials and check again");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
