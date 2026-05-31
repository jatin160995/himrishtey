import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/main.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/auth/signup/signup_two.dart';
import 'package:himrishtey/screens/auth/sigup_success.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/screens/sideMenuScreens/termsAndConditons.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/send_analytics.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/title_text.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/container_radius.dart';
import '../../../widgets/custom_edit_text.dart';

class Signup extends StatefulWidget {
  String profile_created_for;
  String gender;
  Signup(this.profile_created_for, this.gender, {super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isChecked = false;
  bool passwordVisible = false;

  GetValues getValues = new GetValues();

  @override
  void initState() {
    getValues.getallValues();
    print(widget.profile_created_for);
    print(widget.gender);
    emailController.addListener(() {
      if (isEmail(emailController.text)) {
        setState(() {
          isValidEmail = true;
        });
      }
    });
    phoneController.addListener(() {
      setState(() {
        if (phoneController.text.length > 13) {
          phoneController.text = phoneController.text
              .substring(0, phoneController.text.length - 1);
        }
      });
    });

    // Send stats to firebase and Pixel
    sendStats("sign_up", map: {
      'event': 'view',
    });
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        backgroundColor: backgroundLight,
        body: Container(
          child: ListView(
            children: [
              Stack(
                children: [
                  Container(
                    //height: 130,
                    color: white,
                    child: Image.asset("assets/images/baraat.png"),
                  ),
                  SafeArea(
                      child: Container(
                    padding: EdgeInsets.all(10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: textDark(),
                        size: 30,
                      ),
                    ),
                  )),
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: 50,
                    color: white,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: backgroundLight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            headingBig("Signup"),
                            Text(
                              "  for ",
                              style: TextStyle(color: textDark(), fontSize: 14),
                            ),
                            Text(
                                widget.profile_created_for +
                                    " (" +
                                    widget.gender +
                                    ")",
                                style:
                                    TextStyle(color: textDark(), fontSize: 15)),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        title("Full Name"),
                        CustomEditText(
                          true,
                          15,
                          nameController,
                          TextInputType.text,
                          "Full Name",
                          backgroundColor: white,
                        ),
                        title("Email"),
                        CustomEditText(
                          true,
                          15,
                          emailController,
                          TextInputType.text,
                          "Email",
                          backgroundColor: white,
                        ),
                        !isValidEmail
                            ? Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text("Email invalid",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              )
                            : SizedBox(),
                        title("Phone number"),
                        CustomEditText(
                          true,
                          15,
                          phoneController,
                          TextInputType.phone,
                          "Phone number",
                          backgroundColor: white,
                        ),
                        !isValidPhone
                            ? Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text("Enter valid phone number.",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              )
                            : SizedBox(),
                        title("Password"),
                        Stack(
                          children: [
                            CustomEditText(
                              true,
                              15,
                              passwordController,
                              TextInputType.text,
                              "Password",
                              backgroundColor: white,
                              isPassword: !passwordVisible,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                child: Container(
                                    color: transparent,
                                    height: 55,
                                    width: 55,
                                    //color: one,
                                    child: Center(
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        size: 20,
                                        color: passwordVisible
                                            ? primaryColor
                                            : textLightest(),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                        !isValidPassword
                            ? Container(
                                margin: EdgeInsets.only(top: 4),
                                child: Text(
                                    "Password must container atleast 8 characters",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isChecked = !isChecked;
                                });
                              },
                              child: Icon(
                                isChecked
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                                color:
                                    isChecked ? primaryColor : textLightest(),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) =>
                                              TermsAndConditions()));
                                },
                                child: Text(
                                  "I have read and accept the terms and conditons",
                                  style: TextStyle(color: textMedium()),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: borderRadius(transparent, 10),
                          height: 50,
                          clipBehavior: Clip.antiAlias,
                          child: Container(
                            width: double.infinity,
                            //decoration: defaultGradient(),
                            color: isChecked ? primaryColor : Colors.grey,
                            child: TextButton(
                              onPressed: isChecked
                                  ? () {
                                      submitForm();
                                    }
                                  : null,
                              child: isLoading
                                  ? ButtonLoader()
                                  : Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: white,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ),
                        orWidget(),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Auth auth = new Auth();
  bool isLoading = false;
  dynamic values;
  bool isValidEmail = true;
  bool isValidPhone = true;
  bool isValidPassword = true;

  bool isError = false;
  submitForm() async {
    // Send stats to firebase and Pixel
    sendStats("sign_up_clicked", map: {
      'event': 'Clicked',
      'full_name': nameController.text.trim(),
      'phone_number': phoneController.text.trim(),
      'email': emailController.text.trim(),
    });
    if (!isEmail(emailController.text)) {
      setState(() {
        isValidEmail = false;
      });
      showToast("Please enter valid email");
      isError = true;
      return;
    }
    if (phoneController.text.length < 10 || phoneController.text.length > 13) {
      showToast("Please enter valid phone number");
      setState(() {
        isValidPhone = false;
      });
      isError = true;
      return;
    } else {
      isError = false;
    }
    if (passwordController.text.length < 8) {
      setState(() {
        isValidPassword = false;
      });
      showToast("Please enter minimum 8 character password");
      isError = true;
      return;
    }
    if (isError) {
      return;
    }

    if (nameController.text == "" ||
        emailController.text == "" ||
        phoneController.text == "" ||
        passwordController.text == "") {
      showToast("Please fill all fields");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenSaved = prefs.getString("fcmToken").toString();
    Map mapToSend = {
      "profile_completed": "15",
      "full_name": nameController.text.trim(),
      "profile_created_for": widget.profile_created_for,
      "phone_number": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "google_token": tokenSaved,
      "gender": widget.gender
    };
    loadingState(true);
    dynamic responseData = await auth.signupStepOne(mapToSend);
    print(responseData);

    if (responseData['success']) {
      values = responseData['user'];
      setValue(userId, values.toString());
      setValue(password, passwordController.text.trim());
      setValue(email, emailController.text.trim());
      Navigator.pop(context);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignUpTwo()
              //SignUpTwo()
              ));
      print(values);
      loadingState(false);
    } else {
      loadingState(false);
      showToast(responseData['message']);
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  Widget title(String title) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: TextStyle(color: textDark(), fontSize: 12),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget orWidget() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 1,
              width: 100,
              color: textLightest(),
            ),
            Text(
              "    OR    ",
              style:
                  TextStyle(color: textMedium(), fontWeight: FontWeight.normal),
            ),
            Container(
              height: 1,
              width: 100,
              color: textLightest(),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => Login()));
          },
          child: Container(
            height: 40,
            color: transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: textDark(), fontFamily: 'medium'),
                ),
                Text(
                  " Login",
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
