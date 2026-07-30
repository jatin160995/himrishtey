import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/login.dart';
import 'package:himrishtey/screens/auth/signup/signup.dart';
import 'package:himrishtey/screens/auth/signup/signup_two.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/widgets/loader.dart';

class ProfileFor extends StatefulWidget {
  const ProfileFor({super.key});

  @override
  State<ProfileFor> createState() => _ProfileForState();
}

class _ProfileForState extends State<ProfileFor> {
  List texts = [
    "Self",
    "Relative",
    "Son",
    "Daughter",
    "Brother",
    "Sister",
    "Friend",
    "Client (Marriage Bureau)"
  ];
  List icons = [
    Icons.person,
    Icons.people,
    Icons.male,
    Icons.female,
    Icons.boy,
    Icons.girl,
    Icons.home_work_rounded,
    Icons.handshake_rounded
  ];
  dynamic selectedVal = -1;
  bool gender = true;

  @override
  void initState() {
    getValues.getallValues();
    getData();
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
        /*appBar: AppBar(
            backgroundColor: white,
            title: Text(
              'Create Profile For',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),*/
        body: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        color: white,
                        child: Image.asset("assets/images/baraat.png"),
                      ),
                      /*  SafeArea(
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
                      )),*/
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.all(30),
                      child: headingBig("Create profile for")),
                  isLoading
                      ? Loader()
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: backgroundLight,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: getProfiles(),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              selectedVal == 0 ||
                                      selectedVal == 1 ||
                                      selectedVal == 6 ||
                                      selectedVal == 7
                                  ? genderWidget()
                                  : Container()
                            ],
                          ),
                        ),
                  isLoading
                      ? Container()
                      : Column(
                          children: [
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
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              },
                              child: Container(
                                height: 40,
                                color: transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                          color: textDark(),
                                          fontFamily: 'medium'),
                                    ),
                                    Text(
                                      " Login",
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  color: selectedVal == -1 ? dividerColor : primaryColor,
                  width: double.infinity,
                  height: 60,
                  child: TextButton(
                    onPressed: selectedVal == -1
                        ? null
                        : () {
                            if (selectedVal == 2 || selectedVal == 4) {
                              gender = true;
                            } else if (selectedVal == 3 || selectedVal == 5) {
                              gender = false;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Signup(
                                      values[selectedVal]['value'],
                                      gender ? "Male" : "Female")),
                            );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => SignUpTwo()),
                            // );
                          },
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          color: white, fontSize: 16, fontFamily: "medium"),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> getProfiles() {
    List<Widget> widgets = [];
    for (int i = 0; i < values.length; i++) {
      // if (isFunctionalityDisabled() && values[i]['value'] == "Client") {
      //   continue;
      // }
      widgets.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedVal = i;
          });
        },
        child: Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(right: 10, bottom: 10),
          decoration: BoxDecoration(
            border: Border.all(
                color: selectedVal == i ? primaryColor : dividerColor),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Text(
            values[i]['title'],
            textAlign: TextAlign.center,
            style: TextStyle(
                color: selectedVal == i ? primaryColor : textDark(),
                fontSize: 14,
                fontFamily: "medium"),
          ),
        ),
      ));
    }
    return widgets;
  }

  Widget genderWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading("Gender"),
        SizedBox(
          height: 15,
        ),
        Wrap(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  gender = true;
                });
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: gender ? primaryColor : dividerColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  "Male",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: gender ? primaryColor : textDark(),
                      fontSize: 14,
                      fontFamily: "medium"),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  gender = false;
                });
              },
              child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(right: 10, bottom: 10),
                decoration: BoxDecoration(
                  border:
                      Border.all(color: gender ? dividerColor : primaryColor),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Text(
                  "Female",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: gender ? textDark() : primaryColor,
                      fontSize: 14,
                      fontFamily: "medium"),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  GetValues getValues = new GetValues();
  bool isLoading = true;
  dynamic values;
  getData() async {
    dynamic responseData = await getValues.get(profile_for_url);
    loadingState(true);
    if (responseData['success']) {
      values = responseData['user'];

      print(values);
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
