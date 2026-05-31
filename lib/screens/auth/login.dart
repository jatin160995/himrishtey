import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/screens/auth/forgot_password.dart';
import 'package:himrishtey/screens/auth/otp_login.dart';
import 'package:himrishtey/screens/auth/profile_for.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/default_gradient.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/devbhoomi_banner.dart';
import 'package:himrishtey/widgets/no_connection_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:himrishtey/utils/variables/globals.dart' as globals;
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool passwordVisible = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2500), () {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(globals.isHimrishtey!.toString() + "--------status");
    print("Test" + "--------status");
    return Scaffold(
        backgroundColor: backgroundLight,
        bottomNavigationBar: Wrap(
          children: [
            DevbhoomiBanner(),
            NoConnectionBottomBar(),
          ],
        ),
        body: Consumer<Auth>(builder: (context, auth, _) {
          return Container(
            child: ListView(children: [
              Container(
                //height: 130,
                color: white,
                child: Image.asset("assets/images/baraat.png"),
              ),
              Stack(
                children: [
                  Container(
                    height: 50,
                    color: white,
                  ),
                  Container(
                      //color: backgroundLight,
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
                          headingBig("Login"),
                          SizedBox(
                            height: 25,
                          ),
                          Text(
                            "Profile ID / Email / Mobile number",
                            style: TextStyle(color: textDark(), fontSize: 12),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CustomEditText(
                            true,
                            15,
                            emailController,
                            TextInputType.text,
                            "Profile ID / Email / Mobile number",
                            backgroundColor: white,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Password",
                            style: TextStyle(color: textDark(), fontSize: 12),
                          ),
                          SizedBox(
                            height: 8,
                          ),
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
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OtpLogin(1)),
                                  );
                                },
                                child: Container(
                                  height: 30,
                                  color: transparent,
                                  child: Text(
                                    "Forgot Password ?",
                                    style: TextStyle(
                                        color: textMedium(),
                                        fontSize: 13.5,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: borderRadius(transparent, 10),
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            child: Container(
                              width: double.infinity,
                              //decoration: defaultGradient(),
                              color: primaryColor,
                              child: TextButton(
                                onPressed: () {
                                  loginRequest();
                                },
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
                                style: TextStyle(
                                    color: textMedium(),
                                    fontWeight: FontWeight.normal),
                              ),
                              Container(
                                height: 1,
                                width: 100,
                                color: textLightest(),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpLogin(0)),
                                );
                              },
                              child: Container(
                                decoration: borderRadius(primaryAccent, 10),
                                //padding: EdgeInsets.all(12),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_android,
                                      color: primaryColor,
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      "Login with OTP",
                                      style: TextStyle(
                                          color: textDark(),
                                          fontFamily: 'medium'),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 22,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileFor()),
                              );
                            },
                            child: Container(
                              height: 40,
                              color: transparent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account yet? ",
                                    style: TextStyle(
                                        color: textDark(),
                                        fontFamily: 'medium'),
                                  ),
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          !Platform.isIOS
                              ? Container()
                              : Container(
                                  child: globals.isHimrishtey == 1
                                      ? Container(
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              devButton(),
                                              SizedBox(height: 5),
                                              dogriButton()
                                            ],
                                          ),
                                        )
                                      : globals.isHimrishtey == 2
                                          ? Container(
                                              width: double.infinity,
                                              child: Column(
                                                children: [
                                                  himButton(),
                                                  SizedBox(height: 5),
                                                  dogriButton()
                                                ],
                                              ),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  himButton(),
                                                  SizedBox(height: 5),
                                                  devButton()
                                                ],
                                              ),
                                            ),
                                )
                        ],
                      )),
                ],
              )
            ]),
          );
        }));
  }

  himButton() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.pink)),
        onPressed: () {
          _showDevbhoomiDialog(1);
        },
        child: Column(
          children: [
            Text(
              "HimRishtey Users?",
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Himachal Pradesh",
              style: TextStyle(
                  color: white, fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ],
        ));
  }

  devButton() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange)),
        onPressed: () {
          _showDevbhoomiDialog(2);
        },
        child: Column(
          children: [
            Text(
              "Devbhoomi Users?",
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Uttrakhand",
              style: TextStyle(
                  color: white, fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ],
        ));
  }

  dogriButton() {
    return TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.orange)),
        onPressed: () {
          _showDevbhoomiDialog(3);
        },
        child: Column(
          children: [
            Text(
              "DogriRishtey Users?",
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            Text(
              "Jammu & Kashmir",
              style: TextStyle(
                  color: white, fontWeight: FontWeight.normal, fontSize: 12),
            ),
          ],
        ));
  }

  String currentlyWorking = globals.isHimrishtey == 1
      ? "HimRishtey"
      : globals.isHimrishtey == 2
          ? "DevbhoomiRishtey"
          : "Dogri Rishtey";
  //String changingTo = globals.isHimrishtey! ? "DevbhoomiRishtey" : "HimRishtey";

  Future<void> _showDevbhoomiDialog(int changingTo) async {
    String changingToString = changingTo == 1
        ? "HimRishtey"
        : changingTo == 2
            ? "DevbhoomiRishtey"
            : "Dogri Rishtey";
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: Colors.amber,
              ),
              Text(
                '$changingToString User?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you a $changingToString user ?',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                    'By clicking on YES, app will restart and you will be able to use the $changingTo user account in this app. You will not be able to use $currentlyWorking user account.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                setIsHimrishtey(changingTo);
              },
            ),
          ],
        );
      },
    );
  }

  setIsHimrishtey(int isHimRishtey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(isHimrishteyShared, isHimRishtey);
    Restart.restartApp();
  }

  Auth auth = new Auth();
  bool isLoading = false;
  loginRequest() async {
    if (passwordController.text.trim() == "" ||
        emailController.text.trim() == "") {
      showToast("Please fill all fiels");
      return;
    }
    loadingState(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tokenSaved = prefs.getString("fcmToken").toString();
    print({
      "username": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "google_token": tokenSaved
    });
    dynamic responseData = await auth.login({
      "username": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "google_token": tokenSaved
    });

    dynamic data = responseData['user'];

    if (responseData['success']) {
      setValueBool(isLoggedIn, true);
      setValue(userId, data['id']);
      setValue(username, emailController.text.trim());
      setValue(password, passwordController.text.trim());
      setValue(email, data['email']);
      setValue(mobileNumber, data['mobile_number']);
      setValue(fullName, data['full_name']);
      setValue(gender, data['gender']);
      setValue(photo, data['photo']);
      setValue(profileId, data['profile_id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
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
