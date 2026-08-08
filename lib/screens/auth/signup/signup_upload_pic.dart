import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:himrishtey/screens/auth/sigup_success.dart';
import 'package:himrishtey/screens/userScreens/upload_profile_photo.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:image_picker/image_picker.dart';

class SignupUploadPic extends StatefulWidget {
  const SignupUploadPic({super.key});

  @override
  State<SignupUploadPic> createState() => _SignupUploadPicState();
}

class _SignupUploadPicState extends State<SignupUploadPic> {
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  int requiredSeconds = 2;

  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      currentBackPressTime = now;
      showToast("Press back to exit. Signup process will be terminated.");
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
  void initState() {
    // TODO: implement initState
    // getName();
    super.initState();
  }

  String? nameSaved = "";
  getName() async {
    nameSaved = await getString(key: fullName);
    setState(() async {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        backgroundColor: white,
        // appBar: AppBar(
        //   title: headingBig("Upload photo"),
        // ),
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  //height: 130,
                  color: white,
                  child: Image.asset("assets/images/baraat.png"),
                ),
                // SafeArea(
                //     child: Container(
                //   padding: EdgeInsets.all(10),
                //   child: IconButton(
                //     onPressed: () {
                //       Navigator.pop(context);
                //     },
                //     icon: Icon(
                //       Icons.arrow_back_rounded,
                //       color: textDark(),
                //       size: 30,
                //     ),
                //   ),
                // )),
              ],
            ),
            Container(
              width: double.infinity,
              //height: double.infinity,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: borderRadius(backgroundColor(), 10),
                child: Stack(
                  children: [
                    // Align(
                    //     alignment: Alignment.topRight,
                    //     child: Text(
                    //       "Hi " + nameSaved!,
                    //       style: TextStyle(
                    //           color: textMedium(),
                    //           fontSize: 17,
                    //           fontFamily: "medium"),
                    //     )),
                    Container(
                      width: double.infinity,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                            ),
                            GestureDetector(
                              onTap: () {
                                takePhoto();
                              },
                              child: Container(
                                height: 150,
                                width: 150,
                                decoration: borderRadius(darkLightText, 75),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Upload Profile Picture",
                              style: TextStyle(
                                  color: textLightest(), fontFamily: "medium"),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            Container(
                              decoration: borderRadius(primaryAccent, 8),
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupSuccess()),
                                  );
                                },
                                child: Text(
                                  "Skip >",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takePhoto() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      imageQuality: 90,
    );
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UploadProfilePhoto(image, false)),
      );
    }
    print(image?.path);
  }
}
