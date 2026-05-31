import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/controllers/interests_controller.dart';
import 'package:himrishtey/controllers/user_controller.dart';
import 'package:himrishtey/screens/gallery.dart';
import 'package:himrishtey/screens/gallery_detail.dart';
import 'package:himrishtey/screens/membership/membership.dart';
import 'package:himrishtey/screens/membership/membership_ios.dart';
import 'package:himrishtey/screens/wallet/wallet.dart';
import 'package:himrishtey/screens/wallet/wallet_ios.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/loading_image.dart';
import 'package:himrishtey/widgets/title_text.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProfileDetail extends StatefulWidget {
  dynamic userData;
  ProfileDetail(this.userData, {super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  Auth auth = new Auth();
  bool isLoading = true;
  dynamic profileDetail = {};
  dynamic imagesArray = [];

  bool isInterestLoading = false;
  bool isImageLoading = false;

  @override
  void initState() {
    print(widget.userData);
    profileDetail = widget.userData;
    profileDetail['profile_viewed'] = "no";
    imagesArray.add(widget.userData['photo'].toString().contains("member-photo")
        ? (imageUrlPrefix() + widget.userData['photo'].toString())
        : widget.userData['photo']);
    profileRequest();

    super.initState();
  }

  int sliderIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    print(status.toString() + "--- status");

    return Scaffold(
        backgroundColor: backgroundColor(),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                GestureDetector(
                  onTap: () {
                    // showToast("message");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GalleryDetail(
                              sliderIndex, imagesArray, userInfo, true)),
                    );
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Stack(
                      children: [
                        CarouselSlider(
                            items: loadingImageArray(),
                            options: CarouselOptions(
                              height: MediaQuery.of(context).size.height * .8,
                              //aspectRatio: 16 / 9,
                              viewportFraction: 1,
                              initialPage: 0,
                              enableInfiniteScroll: true,
                              reverse: false,
                              autoPlay: true,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              //enlargeCenterPage: true,
                              //enlargeFactor: 0.3,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  sliderIndex = index;
                                });
                              },
                              scrollDirection: Axis.horizontal,
                            )),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.15,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                transparentBlack,
                                transparent,
                              ],
                            )),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                widget.userData['age_years']
                                                        .toString() +
                                                    "y | " +
                                                    widget.userData['height'] +
                                                    " ft",
                                                style: TextStyle(
                                                    color: white,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.userData['full_name'],
                                              // maxLines: 1,
                                              style: TextStyle(
                                                  color: white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                              " | " +
                                                  widget.userData['profile_id'],
                                              // maxLines: 1,
                                              style: TextStyle(
                                                  color: white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              color: darkLightText,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            isLoading
                                                ? Container()
                                                : Text(
                                                    profileDetail[
                                                            'city_living_in'] +
                                                        ", " +
                                                        profileDetail[
                                                            'state_living_in'],
                                                    style: TextStyle(
                                                        color: darkLightText,
                                                        fontSize: 15),
                                                  )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            height: 200,
                            margin: EdgeInsets.only(bottom: 50, right: 0),
                            child: Column(
                              children: [
                                isLoading
                                    ? Container(width: 10)
                                    : isLikeLoading
                                        ? Container(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: primaryAccent,
                                            ))
                                        : TextButton(
                                            onPressed: () {
                                              getDataPost(
                                                  profileDetail['like'] == 'No'
                                                      ? like_url
                                                      : unlike_url,
                                                  profileDetail['id']);
                                            },
                                            child: Container(
                                                height: 35,
                                                width: 35,
                                                child: Image.asset(profileDetail[
                                                            'like'] ==
                                                        'No'
                                                    ? "assets/images/heart.png"
                                                    : "assets/images/heart-filled.png"))),
                                SizedBox(
                                  height: 10,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      _showOptionsBottomSheet(context);
                                    },
                                    child: Container(
                                        height: 35,
                                        width: 35,
                                        child: Image.asset(
                                            "assets/images/share.png"))),
                                SizedBox(
                                  height: 10,
                                ),
                                isLoading
                                    ? Container(width: 10)
                                    : TextButton(
                                        onPressed: () async {
                                          // showToast(profileDetail['shortlisted']);
                                          profileDetail['shortlisted']
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "yes"
                                              ? shortListProfileRequest(
                                                  remove_shortList_profile)
                                              : shortListProfileRequest(
                                                  shortList_profile);
                                        },
                                        child: isShortlistLoading
                                            ? Container(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: primaryAccent,
                                                ))
                                            : Container(
                                                height: 35,
                                                width: 35,
                                                child: Image.asset(profileDetail[
                                                                'shortlisted']
                                                            .toString()
                                                            .toLowerCase() ==
                                                        "yes"
                                                    ? "assets/images/save_filled.png"
                                                    : "assets/images/save.png")))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // isLoading
                //     ? Loader()
                //     :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    basicDetail(),
                    //aboutMe(),
                    kundliDetail(),
                    religionDetail(),
                    contactDetail(),
                    eduDetail(),
                    familyDetail(),
                    lifestyleDetail(),
                    partnerPrefsDetail(),
                    autoGeneratedAbout(),
                    SizedBox(height: 10),
                    Container(
                      decoration: borderRadius(transparent, 8),
                      margin: EdgeInsets.only(left: 15),
                      child: isReportLoading
                          ? Loader()
                          : TextButton(
                              onPressed: () {
                                _showReportDialog();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.report_gmailerrorred_sharp,
                                    color: one,
                                  ),
                                  Text(
                                    "  Report this profile",
                                    style: TextStyle(
                                        color: one, fontFamily: "medium"),
                                  ),
                                ],
                              )),
                    ),
                    SizedBox(height: 120)
                  ],
                )
              ],
            ),
            topBar(),
            isLoading
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 60,
                      color: transparentBlack,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Loading profile for you...",
                            style: TextStyle(color: white),
                          ),
                          SizedBox(width: 20),
                          Container(
                            child: SpinKitPumpingHeart(
                              color: white,
                              size: 30,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        !isSend && status == "0"
                            ? GestureDetector(
                                onTap: () {
                                  acceptInterest("2");
                                },
                                child: Container(
                                  decoration: borderRadius(Colors.red, 15),
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: userInfo['plan_activated'] != "yes"
                                      ? 80
                                      : 50,
                                  // width: userInfo['plan_activated'] != "yes"
                                  //     ? 300
                                  //     : 200,
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Reject ",
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontFamily: "medium"),
                                      ),
                                      isInterestLoading
                                          ? Container(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: white,
                                              ),
                                            )
                                          : Icon(
                                              Icons.cancel,
                                              color: white,
                                              size: 20,
                                            )
                                    ],
                                  )),
                                ),
                              )
                            : Container(
                                height: userInfo['plan_activated'] != "yes"
                                    ? 100
                                    : 60,
                              ),
                        Container(
                          height: userInfo['plan_activated'] != "yes" ? 80 : 50,
                          // width:
                          //     userInfo['plan_activated'] != "yes" ? 300 : 200,
                          margin: EdgeInsets.only(bottom: 20),
                          decoration: borderRadius(
                              status == "2" || (isSend && status == "0")
                                  ? Colors.red
                                  : (!isSend && status == "1")
                                      ? five
                                      : profileDetail['interest'] == "0"
                                          ? Colors.blue
                                          : five,
                              15),
                          child: TextButton(
                            onPressed: () {
                              userInfo['plan_activated'] != "yes"
                                  ? Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => Membership()))
                                  : !isSend && status == "0"
                                      ? acceptInterest("1")
                                      : status == "1" || status == "2"
                                          ? () {}
                                          : (isSend && status == "0")
                                              ? deleteInterest()
                                              : sendInterestsRequest();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      userInfo['plan_activated'] != "yes"
                                          ? "Activate membership"
                                          // : status == 1
                                          //     ? "Matched"
                                          //     : isSend && status == 0
                                          //         ? "Sent"
                                          //         : isSend && status == 2
                                          //             ? "Rejected"
                                          //             : !isSend && status == 0
                                          //                 ? "Accept Interest"
                                          //                 : !isSend && status == 0
                                          //                     ? "You Rejected"
                                          //                     : "Send Interest",
                                          : !isSend && status == "0"
                                              ? "Accept "
                                              : status == "1"
                                                  ? "Matched "
                                                  : status == "2"
                                                      ? "Rejected "
                                                      : profileDetail[
                                                                  'interest'] ==
                                                              "0"
                                                          ? "Send Interest "
                                                          : isSend &&
                                                                  status == "0"
                                                              ? "Interest sent. Delete Interest ?"
                                                              : "Interest Sent ",
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 14,
                                          fontFamily: "medium"),
                                    ),
                                    userInfo['plan_activated'] != "yes"
                                        ? Text(
                                            "to send intersts",
                                            style: TextStyle(color: white),
                                          )
                                        : Container()
                                  ],
                                ),
                                isInterestLoading
                                    ? Container(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(
                                          color: white,
                                        ),
                                      )
                                    : isSend && status == "0"
                                        ? Container()
                                        : Icon(
                                            status == "2"
                                                ? Icons.close
                                                : status == "1"
                                                    ? Icons.favorite
                                                    : profileDetail[
                                                                'interest'] ==
                                                            "0"
                                                        ? Icons.send_rounded
                                                        : Icons.done,
                                            color: white,
                                            size: 20,
                                          )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ],
        ));
  }

  void _showReportDialog() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.all(15),
            child: ListView(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    heading("Report"),
                    SizedBox(height: 20),
                    heading("Why are you reporting this profile?"),
                    Text(
                      "Please select the appropriate reason to report this profile. Your report is anonymous. We will check your request and take the require action.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textLightest(), fontSize: 12),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reportWidgets("I don't like this profile."),
                          reportWidgets("Bullying or unwanted content."),
                          reportWidgets("Violence, hate or exploitation."),
                          reportWidgets(
                              "Selling or promoting restricted items."),
                          reportWidgets("Nudity or sexual activity."),
                          reportWidgets("Scam, fraud or spam."),
                          reportWidgets("False Information."),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }

  bool isReportLoading = false;
  reportProfile(String reason) async {
    loadingReportState(true);
    var user_id = await getString(key: userId);

    dynamic responseData = await getValues.getValues(report_profile_url, {
      'user_id': user_id,
      "profile_id": profileDetail['id'],
      "reason": reason
    });

    print(responseData.toString());

    if (responseData['success']) {
      Navigator.pop(context);
      showReportSuccessDialog(context);
      loadingReportState(false);
    } else {
      loadingReportState(false);
      //profileArray = [];
      //showToast("Something went wrong");
      return [];
    }
  }

  void showReportSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Submitted"),
          content: Text(
              "Thank you for reporting this profile. Our team will review the report promptly and take appropriate action to ensure a safe and respectful community. We appreciate your help in maintaining a positive environment."),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  reportWidgets(String text) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        reportProfile(text);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text,
          style:
              TextStyle(color: textDark(), fontFamily: "medium", fontSize: 15),
        ),
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.manage_accounts_rounded),
                title: Text('Share with your Relationship manager'),
                onTap: () {
                  // Handle 'Edit' action
                  shareToManager();
                  // Navigator.pop(context); // Close the bottom sheet
                },
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
                onTap: () async {
                  Navigator.pop(context);
                  shareData();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  shareToManager() async {
    final result = "*" +
        widget.userData['full_name'] +
        "* \n" +
        "Created by " +
        profileDetail['profile_created_for'] +
        "\n" +
        widget.userData['age_years'].toString() +
        " years\nProfile id - " +
        profileDetail['profile_id'] +
        "\n" +
        profileDetail['religion'] +
        "\n" +
        profileDetail['cast'] +
        "\n" +
        profileDetail['birth_place'] +
        "\n" +
        "About : " +
        profileDetail['about_me'] +
        "\nCommunity : " +
        profileDetail['cast'] +
        "\nSub Community : " +
        (profileDetail['sub_cast'] == "" ? "N/A" : profileDetail['sub_cast']) +
        "\nGotra : " +
        profileDetail['gotra'] +
        "\nNative Place : " +
        profileDetail['native_place'] +
        "\nEducation : " +
        profileDetail['education'].toString().trim() +
        "\nOther qualification : " +
        profileDetail['any_other_qualifications'] +
        "\nEmployed in : " +
        profileDetail['employed_in'] +
        "\nOccupation : " +
        profileDetail['occupation'] +
        "\nCurrently working : " +
        profileDetail['occupation'] +
        "\nFamily type : " +
        profileDetail['family_type'] +
        "\nFather Occupation : " +
        profileDetail['father_occupation'] +
        "\nMother Occupation : " +
        profileDetail['mother_occupation'] +
        "\nBrother : " +
        profileDetail['no_of_brothers'] +
        "\nMarried Brother : " +
        profileDetail['married_brothers'] +
        "\nSisters : " +
        profileDetail['no_of_sisters'] +
        "\nMarried Sisters : " +
        profileDetail['married_sisters'] +
        "\nDiet : " +
        profileDetail['diet'] +
        "\nSmoking : " +
        profileDetail['is_smoking'] +
        "\nDrinking : " +
        profileDetail['is_drinking'] +
        "\nAny disabilty : " +
        profileDetail['any_disability'] +
        " \n\n*Partner Preferences*\n\n" +
        "Height : " +
        profileDetail['partner_height_from'] +
        "-" +
        profileDetail['partner_height_to'] +
        "\nAge : " +
        profileDetail['partner_age_from'] +
        "-" +
        profileDetail['partner_age_to'] +
        "\nMarital status : " +
        profileDetail['looking_for'] +
        "\nReligion & Mother tongue : " +
        profileDetail['partner_mothertongue'] +
        "\n" +
        profileDetail['partner_religion'] +
        "\nCommunity : " +
        profileDetail['partner_cast'] +
        "\nIs Manglik : " +
        (profileDetail['is_partner_manglik'] == ""
            ? "No"
            : profileDetail['is_partner_manglik']) +
        "\nHighest Qualification :" +
        profileDetail['partner_education'] +
        "\nPartner Occupation : " +
        (profileDetail['partner_occupation'] == ""
            ? "N/A"
            : profileDetail['partner_occupation']) +
        "\nAnnual Income(in Lacs) : " +
        (profileDetail['partner_annual_income_from'] +
            "-" +
            profileDetail['partner_annual_income_to']);
    await launch("https://wa.me/" +
        userInfo['relationship_manager_number'] +
        "?text=" +
        result.toString());
  }

  shareData() async {
    showLoadingDialog(context, "Loading assets to share");
    String localPath = await downloadImage(imagesArray[0]);
    hideLoadingDialog(context);
    final result = await Share.shareXFiles([XFile(localPath)],
        text: "*" +
            widget.userData['full_name'] +
            "* \n" +
            "Created by " +
            profileDetail['profile_created_for'] +
            "\n" +
            widget.userData['age_years'].toString() +
            " years\nProfile id - " +
            profileDetail['profile_id'] +
            "\n" +
            profileDetail['religion'] +
            "\n" +
            profileDetail['cast'] +
            "\n" +
            profileDetail['birth_place'] +
            "\n" +
            "About : " +
            profileDetail['about_me'] +
            "\nCommunity : " +
            profileDetail['cast'] +
            "\nSub Community : " +
            (profileDetail['sub_cast'] == ""
                ? "N/A"
                : profileDetail['sub_cast']) +
            "\nGotra : " +
            profileDetail['gotra'] +
            "\nNative Place : " +
            profileDetail['native_place'] +
            "\nEducation : " +
            profileDetail['education'].toString().trim() +
            "\nOther qualification : " +
            profileDetail['any_other_qualifications'] +
            "\nEmployed in : " +
            profileDetail['employed_in'] +
            "\nOccupation : " +
            profileDetail['occupation'] +
            "\nCurrently working : " +
            profileDetail['occupation'] +
            "\nFamily type : " +
            profileDetail['family_type'] +
            "\nFather Occupation : " +
            profileDetail['father_occupation'] +
            "\nMother Occupation : " +
            profileDetail['mother_occupation'] +
            "\nBrother : " +
            profileDetail['no_of_brothers'] +
            "\nMarried Brother : " +
            profileDetail['married_brothers'] +
            "\nSisters : " +
            profileDetail['no_of_sisters'] +
            "\nMarried Sisters : " +
            profileDetail['married_sisters'] +
            "\nDiet : " +
            profileDetail['diet'] +
            "\nSmoking : " +
            profileDetail['is_smoking'] +
            "\nDrinking : " +
            profileDetail['is_drinking'] +
            "\nAny disabilty : " +
            profileDetail['any_disability'] +
            " \n\n*Partner Preferences*\n\n" +
            "Height : " +
            profileDetail['partner_height_from'] +
            "-" +
            profileDetail['partner_height_to'] +
            "\nAge : " +
            profileDetail['partner_age_from'] +
            "-" +
            profileDetail['partner_age_to'] +
            "\nMarital status : " +
            profileDetail['looking_for'] +
            "\nReligion & Mother tongue : " +
            profileDetail['partner_mothertongue'] +
            "\n" +
            profileDetail['partner_religion'] +
            "\nCommunity : " +
            profileDetail['partner_cast'] +
            "\nIs Manglik : " +
            (profileDetail['is_partner_manglik'] == ""
                ? "No"
                : profileDetail['is_partner_manglik']) +
            "\nHighest Qualification :" +
            profileDetail['partner_education'] +
            "\nPartner Occupation : " +
            (profileDetail['partner_occupation'] == ""
                ? "N/A"
                : profileDetail['partner_occupation']) +
            "\nAnnual Income(in Lacs) : " +
            (profileDetail['partner_annual_income_from'] +
                "-" +
                profileDetail['partner_annual_income_to']));
  }

  Future<String> downloadImage(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Uint8List bytes = response.bodyBytes;

      // Get the app's documents directory
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();

      // Create a file with a unique name
      String filePath =
          '${appDocumentsDirectory.path}/image_${DateTime.now().millisecondsSinceEpoch}.png';
      File imageFile = File(filePath);

      // Write the bytes to the file
      await imageFile.writeAsBytes(bytes);

      return filePath;
    } else {
      // Handle error, for example, show an error message
      throw Exception('Failed to download image: ${response.statusCode}');
    }
  }

  bool isFriends = false;
  bool isSend = false;
  dynamic status = 0;

  profileRequest() async {
    loadingState(true);
    dynamic responseData = await auth.getOtherProfile(widget.userData['id']);

    if (responseData['success']) {
      profileDetail = responseData['data']['user'];
      //print(responseData['interests_received'].toString() + "--- status");
      //print(responseData['interests_sent'].toString() + "--- status");
      if (responseData['interests_received'] != null) {
        if (responseData['interests_received'].length > 0) {
          isSend = false;
          status = responseData['interests_received'][0]['status'].toString();
        }
      }
      if (responseData['interests_sent'] != null && status != "1") {
        if ((responseData['interests_sent']).length > 0) {
          isSend = true;
          status = responseData['interests_sent'][0]['status'].toString();
        }
      }

      List imagesArrayTemp = responseData['images'];
      for (var image in imagesArrayTemp) {
        imagesArray.add(image);
      }

      print(profileDetail.toString());
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong");
    }
  }

  bool isShortlistLoading = false;
  UserController userController = new UserController();
  shortListProfileRequest(String url) async {
    loadingShortListState(true);
    dynamic responseData =
        await userController.shortListProfile(widget.userData['id'], url);

    if (responseData['success']) {
      profileDetail['shortlisted'] = url == shortList_profile ? "yes" : "no";
      showSnackBar(
          context,
          url == shortList_profile
              ? "Profile shortlisted"
              : "Profile removed from shortlist");
      Observable.instance.notifyObservers(
          [
            horizontal_grid_observer,
          ],
          notifyName: update_shortlist_profiles,
          map: {});
      print(responseData.toString());
      loadingShortListState(false);
    } else {
      loadingShortListState(false);
      showToast("Something went wrong");
    }
  }

  bool isLikeLoading = false;
  getDataPost(String url, String profileId) async {
    loadingLikeState(true);
    String? userIdSaved = await getString(key: userId);
    dynamic responseData = await getValues
        .getValues(url, {'profile_id': profileId, 'user_id': userIdSaved});

    if (responseData['success']) {
      loadingLikeState(false);
      if (url == unlike_url) {
        profileDetail['like'] = 'No';
      } else {
        profileDetail['like'] = 'Yes';
      }

      return;
    } else {
      loadingLikeState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  loadingLikeState(bool state) {
    setState(() {
      isLikeLoading = state;
    });
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  loadingShortListState(bool state) {
    setState(() {
      isShortlistLoading = state;
    });
  }

  loadingReportState(bool state) {
    setState(() {
      isReportLoading = state;
    });
  }

  InterestController interestController = new InterestController();

  sendInterestsRequest() async {
    // showToast("message");
    // loadingInterestState(true);
    // setState(() {
    //   profileDetail['interest'] = "1";
    // });
    // return;
    loadingInterestState(true);
    dynamic responseData =
        await interestController.sendInterests(widget.userData['id']);

    if (responseData['success']) {
      setState(() {
        profileDetail['interest'] = "1";
        isSend = true;
        status = "0";
      });
      print(profileDetail.toString());
      loadingInterestState(false);
    } else {
      loadingInterestState(false);
      showToast("Something went wrong");
    }
  }

  loadingInterestState(bool state) {
    setState(() {
      isInterestLoading = state;
    });
  }

  acceptInterest(String status1) async {
    loadingInterestState(true);
    dynamic responseData = await interestController.acceptInterests(
        widget.userData['id'], status1);

    if (responseData['success']) {
      setState(() {
        profileDetail['interest'] = status1;
        isSend = false;
        status = status1;
        if (status == "2") {
          Navigator.pop(context);
          showToast("Interest Rejected");
        }
      });
      print(profileDetail.toString());
      loadingInterestState(false);
    } else {
      loadingInterestState(false);
      showToast("Something went wrong");
    }
  }

  deleteInterest() async {
    print("delete");
    loadingInterestState(true);
    dynamic responseData =
        await interestController.deleteInterests(widget.userData['id']);

    if (responseData['success']) {
      setState(() {
        status = true;
        profileDetail['interest'] = "0";
      });
      print(profileDetail.toString());
      loadingInterestState(false);
    } else {
      loadingInterestState(false);
      showToast("Something went wrong");
    }
  }

  List<Widget> loadingImageArray() {
    List<Widget> imgArray = [];
    for (int i = 0; i < imagesArray.length; i++) {
      imgArray.add(LoadingImage(imagesArray[i]));
    }

    return imgArray;
  }

  autoGeneratedAbout() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading("About"),
          Text("Thank you for visiting my profile. " +
              "I am " +
              profileDetail['height'].toString() +
              " and " +
              widget.userData['age_years'].toString() +
              " years old." +
              " I belong to " +
              profileDetail['city_living_in'] +
              ". I am looking for sutiable match. If you find my profile suitable, please contact me."),
          SizedBox(
            height: 5,
          ),
          Text(profileDetail['about_me'])
        ],
      ),
    );
  }

  eduDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/education.png",
                height: 30,
                width: 30,
                color: Colors.green[800],
              ),
              SizedBox(
                width: 8,
              ),
              heading("Education & Career"),
            ],
          ),
          SizedBox(height: 8),
          TitleText(
              "About my education & career",
              profileDetail['about_my_education'] +
                  " | " +
                  profileDetail['about_my_career']),
          SizedBox(height: 10),
          TitleText("Education", profileDetail['education'].toString().trim()),
          SizedBox(height: 10),
          TitleText(
              "Other qualification",
              profileDetail['any_other_qualifications'] == ""
                  ? "N/A"
                  : profileDetail['any_other_qualifications']),
          SizedBox(height: 10),
          TitleText("Employed in", profileDetail['employed_in']),
          SizedBox(height: 10),
          TitleText("Occupation", profileDetail['occupation']),
          // SizedBox(height: 10),
          // TitleText("Currently working", profileDetail['occupation']),
          SizedBox(height: 10),
          TitleText("Currently working", profileDetail['organization_name']),
          SizedBox(height: 10),
          TitleText("Job location", profileDetail['job_location']),
          SizedBox(height: 10),

          TitleText("Annual Income", profileDetail['annual_income']),
        ],
      ),
    );
  }

  religionDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/religion.png",
                height: 30,
                width: 30,
                color: Colors.orange,
              ),
              SizedBox(
                width: 8,
              ),
              heading("Religion Information"),
            ],
          ),
          SizedBox(height: 8),
          TitleText("Community", profileDetail['cast']),
          SizedBox(height: 10),
          TitleText(
              "Sub Community",
              profileDetail['sub_cast'] == ""
                  ? "N/A"
                  : profileDetail['sub_cast']),
          SizedBox(height: 10),
          TitleText("Gotra", profileDetail['gotra']),
          SizedBox(height: 10),
          TitleText("Native Place", profileDetail['native_place']),
          SizedBox(height: 10),
          TitleText("Mother Tongue", profileDetail['mother_tongue']),
        ],
      ),
    );
  }

  partnerPrefsDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/partner.png",
                height: 30,
                width: 30,
                color: Colors.redAccent,
              ),
              SizedBox(
                width: 8,
              ),
              heading("Partner Preferences"),
            ],
          ),
          TitleText("About my partner", profileDetail['about_my_partner']),
          SizedBox(height: 8),
          TitleText(
              "Height",
              profileDetail['partner_height_from'] +
                  "-" +
                  profileDetail['partner_height_to']),
          SizedBox(height: 10),
          TitleText(
              "Age",
              profileDetail['partner_age_from'] +
                  "-" +
                  profileDetail['partner_age_to']),
          SizedBox(height: 10),
          TitleText("Marital status", profileDetail['looking_for']),
          SizedBox(height: 10),
          TitleText(
              "Religion & Mother tongue",
              profileDetail['partner_mothertongue'] +
                  " | " +
                  profileDetail['partner_religion']),
          SizedBox(height: 10),
          TitleText("Community", profileDetail['partner_cast']),
          SizedBox(height: 10),
          TitleText(
              "Is Manglik",
              profileDetail['is_partner_manglik'] == ""
                  ? "No"
                  : profileDetail['is_partner_manglik']),
          SizedBox(height: 10),
          TitleText(
              "Highest Qualification", profileDetail['partner_education']),
          SizedBox(height: 10),
          TitleText(
              "Partner Occupation",
              profileDetail['partner_occupation'] == ""
                  ? "N/A"
                  : profileDetail['partner_occupation']),
          SizedBox(height: 10),
          TitleText(
              "Annual Income",
              profileDetail['partner_annual_income_from'] +
                  "-" +
                  profileDetail['partner_annual_income_to']),
        ],
      ),
    );
  }

  familyDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/family.png",
                height: 30,
                width: 30,
                color: Colors.teal,
              ),
              SizedBox(
                width: 8,
              ),
              heading("Family Details"),
            ],
          ),
          SizedBox(height: 8),
          TitleText("About my family", profileDetail['about_family']),
          SizedBox(height: 10),
          TitleText("Father Occupation", profileDetail['father_occupation']),
          SizedBox(height: 10),
          TitleText("Mother Occupation", profileDetail['mother_occupation']),
          SizedBox(height: 10),
          TitleText("Brother", profileDetail['no_of_brothers']),
          SizedBox(height: 10),
          TitleText("Married Brother", profileDetail['married_brothers']),
          SizedBox(height: 10),
          TitleText("Sisters", profileDetail['no_of_sisters']),
          SizedBox(height: 10),
          TitleText("Married Sisters", profileDetail['married_sisters']),
          SizedBox(height: 10),
          TitleText("Native Place", profileDetail['native_place']),
        ],
      ),
    );
  }

  lifestyleDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/lifestyle.png",
                height: 30,
                width: 30,
                color: Colors.yellow[800],
              ),
              SizedBox(
                width: 8,
              ),
              heading("Lifestyle"),
            ],
          ),
          SizedBox(height: 8),
          TitleText("Diet",
              profileDetail['diet'] == "" ? "N/A" : profileDetail['diet']),
          SizedBox(height: 10),
          TitleText(
              "Smoking",
              profileDetail['is_smoking'] == ""
                  ? "N/A"
                  : profileDetail['is_smoking']),
          SizedBox(height: 10),
          TitleText(
              "Drinking",
              profileDetail['is_drinking'] == ""
                  ? "N/A"
                  : profileDetail['is_drinking']),
          SizedBox(height: 10),
          TitleText(
              "Any disabilty",
              profileDetail['any_disability'] == ""
                  ? "No"
                  : profileDetail['any_disability']),
        ],
      ),
    );
  }

  basicDetail() {
    //DateTime dt1 = DateTime.parse(profileDetail['birth_date_time']);
    DateTime dt2 = DateTime.now();
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/couple.png",
                height: 30,
                width: 30,
                color: primaryColor,
              ),
              SizedBox(
                width: 8,
              ),
              heading("Basic details"),
            ],
          ),
          SizedBox(height: 8),
          Text(profileDetail['about_me']),
          SizedBox(height: 8),
          Text(
            "Created by " +
                profileDetail['profile_created_for'] +
                " | " +
                widget.userData['age_years'].toString() +
                " years | Profile id - " +
                profileDetail['profile_id'] +
                " | " +
                profileDetail['religion'] +
                " | " +
                profileDetail['cast'] +
                " | " +
                profileDetail['birth_place'] +
                "",
            style: TextStyle(color: textMedium(), fontSize: 14),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              tag(profileDetail['marital_status']),
              SizedBox(
                width: 10,
              ),
              profileDetail['marital_status'] == "Divorcee" ||
                      profileDetail['marital_status'] == "Widow" ||
                      profileDetail['marital_status'] == "Separated"
                  ? tag("No. of Children : " +
                      (profileDetail['no_of_child'] == ""
                          ? "0"
                          : profileDetail['no_of_child']))
                  : Container()
            ],
          )
        ],
      ),
    );
  }

  contactDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/contact.png",
                height: 30,
                width: 30,
                color: Colors.deepOrange,
              ),
              SizedBox(
                width: 8,
              ),
              heading("Contact details"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (profileDetail['profile_viewed']
                          .toString()
                          .toLowerCase() ==
                      "yes") {
                    _launchUrl(
                        Uri.parse("tel:" + profileDetail['mobile_number']));
                  }
                },
                child: TitleText(
                    "Contact number",
                    profileDetail['mobile_number'] == ""
                        ? "N/A"
                        : profileDetail['profile_viewed']
                                    .toString()
                                    .toLowerCase() ==
                                "no"
                            ? profileDetail['mobile_number']
                                .toString()
                                .replaceRange(0, 6, "******")
                            : profileDetail['mobile_number'].toString()),
              ),
              lockWidget()
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (profileDetail['profile_viewed']
                          .toString()
                          .toLowerCase() ==
                      "yes") {
                    _launchUrl(Uri.parse(
                        "https://wa.me/" + profileDetail['whatsapp_number']));
                  }
                },
                child: TitleText(
                    "Whatsapp number",
                    profileDetail['whatsapp_number'] == ""
                        ? "N/A"
                        : profileDetail['profile_viewed']
                                    .toString()
                                    .toLowerCase() ==
                                "no"
                            ? profileDetail['whatsapp_number']
                                .toString()
                                .replaceRange(
                                    0,
                                    profileDetail['whatsapp_number']
                                            .toString()
                                            .length -
                                        1,
                                    "******")
                            : profileDetail['whatsapp_number'].toString()),
              ),
              lockWidget()
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (profileDetail['profile_viewed']
                          .toString()
                          .toLowerCase() ==
                      "yes") {
                    _launchUrl(Uri.parse("mailto:" + profileDetail['email']));
                  }
                },
                child: TitleText(
                    "Email id",
                    profileDetail['email'] == ""
                        ? "N/A"
                        : profileDetail['profile_viewed']
                                    .toString()
                                    .toLowerCase() ==
                                "no"
                            ? profileDetail['email'].toString().replaceRange(
                                0,
                                profileDetail['email'].toString().length - 2,
                                "*********")
                            : profileDetail['email']),
              ),
              lockWidget()
            ],
          ),
          SizedBox(
            height: 10,
          ),
          profileDetail['profile_viewed'].toString().toLowerCase() == "no"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Want to get full information",
                      style: TextStyle(color: textLightest(), fontSize: 12),
                    ),
                  ],
                )
              : Container(),
          profileDetail['profile_viewed'].toString().toLowerCase() == "no"
              ? isLoadingView
                  ? Loader()
                  : Container(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            if (isLoading) {
                              showToast("Loading data please wait.");
                              return;
                            }
                            if (userInfo['plan_activated'] != "yes") {
                              showSnackBar(context, "Activate Membership");
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Membership()));
                            } else {
                              _showViewContactDialog();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Unlock now",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 14,
                                    fontFamily: "medium"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.lock_open_rounded,
                                color: white,
                                size: 19,
                              )
                            ],
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.deepOrange))),
                    )
              : Container()
        ],
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }

  aboutMe() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/about.png",
                height: 30,
                width: 30,
                color: Colors.indigo,
              ),
              SizedBox(
                width: 8,
              ),
              heading("About me"),
            ],
          ),
          SizedBox(height: 8),
          Text(
            profileDetail['about_me'] == "" ? "N/A" : profileDetail['about_me'],
            style: TextStyle(color: textMedium(), fontSize: 14),
          ),
          SizedBox(height: 5),
          //tag("Never Married")
        ],
      ),
    );
  }

  kundliDetail() {
    return Container(
      decoration: borderRadius(lightBackgroundColor(), 8),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/images/horoscope.png",
                height: 30,
                width: 30,
                color: Colors.blue,
              ),
              SizedBox(
                width: 8,
              ),
              heading("Astro and Kundli details"),
            ],
          ),
          SizedBox(height: 10),
          TitleText(
              "Date of birth",
              readableDate(profileDetail[
                  'birth_date_time'])), //profileDetail['birth_date_time'].toString().split(" ")[0]),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                  "Time of birth  ",
                  // profileDetail['profile_viewed'].toString().toLowerCase() ==
                  //         "no"
                  //     ?
                  userInfo['plan_activated'] != 'yes'
                      ? "**:** **"
                      : readableTime(profileDetail['birth_date_time'])),
              //lockWidget()
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(
                  "Place of birth",
                  profileDetail['birth_place'].toString() == "" ||
                          profileDetail['birth_place'].toString() == "null"
                      ? "N/A"
                      :
                      // profileDetail['profile_viewed']
                      //             .toString()
                      //             .toLowerCase() ==
                      //         "no"
                      userInfo['plan_activated'] != 'yes'
                          ? (profileDetail['birth_place']
                                  .toString()
                                  .substring(0, 1) +
                              "***") //profileDetail['birth_place']
                          //     .toString()
                          //     .replaceRange(
                          //         0,
                          //         profileDetail['birth_place']
                          //                 .toString()
                          //                 .length -
                          //             3,
                          //         "****")
                          : profileDetail['birth_place']),
            ],
          ),
          SizedBox(height: 10),
          TitleText("Manglik", profileDetail['manglik']),
          SizedBox(
            height: 10,
          ),
          // profileDetail['profile_viewed'].toString().toLowerCase() == "no"
          userInfo['plan_activated'] != 'yes'
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Want to get full information",
                      style: TextStyle(color: textLightest(), fontSize: 12),
                    ),
                  ],
                )
              : Container(),
          //  profileDetail['profile_viewed'].toString().toLowerCase() == "no"
          userInfo['plan_activated'] != 'yes'
              ? isLoadingView
                  ? Loader()
                  : Container(
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            if (userInfo['plan_activated'] != "yes") {
                              showSnackBar(context, "Activate Membership");
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => Membership()));
                            } else {
                              _showViewContactDialog();
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Unlock now",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 14,
                                    fontFamily: "medium"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.lock_open_rounded,
                                color: white,
                                size: 19,
                              )
                            ],
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue))),
                    )
              : Container()
        ],
      ),
    );
  }

  tag(String text) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 6),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Text(
        text,
        style: TextStyle(color: textDark(), fontFamily: "medium"),
      ),
      decoration: BoxDecoration(
          color: Colors.blueGrey[100],
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: Colors.blueGrey[100]!)),
    );
  }

  lockWidget() {
    return profileDetail['profile_viewed'].toString().toLowerCase() == "no"
        ? Icon(
            Icons.lock,
            color: textMedium(),
            size: 20,
          )
        : Container();
  }

  Future<void> _showViewContactDialog() async {
    double profileCost =
        double.parse(profileDetail['profile_view_price'].toString());
    double walletBalance = double.parse(userInfo['wallet_amount']);
    bool isBalanceLow = false;
    if (walletBalance < profileCost) {
      isBalanceLow = true;
    }
    // if (Platform.isIOS) {
    //   if (isBalanceLow) {
    //     showContactDialog(context,
    //         'View all the locked profiles. Get in touch with us to get more info about these locked profiles.');
    //   } else {
    //     viewContactData();
    //   }
    //   return;
    // }
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: white,
          title: Text(
            'Unlock Profile',
            style: TextStyle(
                color: textDark(), fontFamily: "medium", fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  widget.userData['full_name'],
                  style: TextStyle(
                      color: textDark(),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Profile view price :"),
                    Text(currencySign +
                        profileDetail['profile_view_price'].toString()),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: borderRadius(white, 20),
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Wallet Balance :"),
                          isBalanceLow
                              ? Text(
                                  "Low balance",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                )
                              : Container(),
                        ],
                      ),
                      Text(currencySign + userInfo['wallet_amount'].toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('cancel', style: TextStyle(color: darkText)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Container(
              decoration: borderRadius(primaryColor, 20),
              child: TextButton(
                child: Text(
                  isBalanceLow ? "Add Balance" : "Unlock",
                  style: TextStyle(color: white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  isBalanceLow
                      ? Platform.isIOS
                          ? Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => WalletIos()))
                          : Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => Wallet()))
                      : viewContactData();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  bool isLoadingView = false;
  GetValues getValues = new GetValues();
  viewContactData() async {
    viewContactloadingState(true);
    String? userIdSaved = await getString(key: userId);
    dynamic responseData = await getValues.getValues(view_profile_url, {
      "user_id": userIdSaved,
      "profile_id": profileDetail['id'],
      "profile_amount": profileDetail['profile_view_price'],
    });
    if (responseData['success']) {
      viewContactloadingState(false);
      profileDetail['profile_viewed'] = 'Yes';
      Observable.instance.notifyObservers([home_observer],
          notifyName: profile_updater, map: {});
      setState(() {});
    } else {
      viewContactloadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  viewContactloadingState(bool state) {
    setState(() {
      isLoadingView = state;
    });
  }

  topBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: borderRadius(transparentBlack, 40),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: white,
                    ),
                  )),
              isLoading
                  ? Container()
                  : TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Gallery(imagesArray, widget.userData, false)),
                        );
                      },
                      child: Container(
                        decoration: borderRadius(transparentBlack, 40),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: white,
                            ),
                            Text(
                              "Gallery",
                              style: TextStyle(color: white, fontSize: 12.5),
                            )
                          ],
                        ),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
