import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/signup/signup_upload_pic.dart';
import 'package:himrishtey/screens/auth/sigup_success.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';

class SignUpFour extends StatefulWidget {
  const SignUpFour({super.key});

  @override
  State<SignUpFour> createState() => _SignUpFourState();
}

class _SignUpFourState extends State<SignUpFour> {
  bool isLoading = false;
  TextEditingController maritalController = TextEditingController();
  TextEditingController toungueController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController castController = TextEditingController();
  TextEditingController manglikController = TextEditingController();
  TextEditingController horoscopeController = TextEditingController();
  TextEditingController childController = TextEditingController();

  dynamic selectedCountryId = 0;
  dynamic selectedStateId = 0;

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
    print(maritalController.text);
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          title: headingBig("Signup"),
        ),
        bottomNavigationBar: Container(
          height: 60,
          color: primaryColor,
          child: TextButton(
            onPressed: () {
              submitForm();
            },
            child: isLoading
                ? ButtonLoader()
                : Text(
                    "Submit",
                    style: TextStyle(
                        color: white, fontSize: 16, fontFamily: "medium"),
                  ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 20),
            progress(),
            SizedBox(
              height: 20,
            ),

            // SizedBox(height: 10),
            // smallHeading("Profile Created For"),
            // GestureDetector(
            //   onTap: () {
            //     //  showToast("message");
            //     dialogBox(profile_for_url, "user", "value",
            //         profileCreatedForController);
            //   },
            //   child: CustomEditText(false, 15, profileCreatedForController,
            //       TextInputType.text, "Profile Created For",
            //       backgroundColor: Color(0xFFf8f8f8)),
            // ),

            SizedBox(height: 10),
            smallHeading("Marital Status"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(maritals, "Marital_Status", "marital_status",
                    maritalController);
              },
              child: CustomEditText(false, 15, maritalController,
                  TextInputType.text, "Marital Status",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Mother Tongue"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(toungues, "Mother_Tongues", "mother_tongue",
                    toungueController);
              },
              child: CustomEditText(false, 15, toungueController,
                  TextInputType.text, "Mother Tongue",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Religion"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(
                    religions, "Religions", "religion", religionController);
              },
              child: CustomEditText(
                  false, 15, religionController, TextInputType.text, "Religion",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Cast"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(casts, "Casts", "cast", castController);
              },
              child: CustomEditText(
                  false, 15, castController, TextInputType.text, "Cast",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Manglik"),
            GestureDetector(
              onTap: () {
                // dialogBox(income_url, "Annual_Incomes", "annual_income",
                //     incomeController);
                staticDialigBox(manglikController, ["Yes", "No"]);
              },
              child: CustomEditText(
                  false, 15, manglikController, TextInputType.text, "Manglik",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Horoscope Needed"),
            GestureDetector(
              onTap: () {
                // dialogBox(income_url, "Annual_Incomes", "annual_income",
                //     incomeController);
                staticDialigBox(horoscopeController, ["Yes", "No"]);
              },
              child: CustomEditText(false, 15, horoscopeController,
                  TextInputType.text, "Horoscope Needed",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            maritalController.text != "Never Married"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallHeading("Children"),
                      GestureDetector(
                        onTap: () {
                          // dialogBox(income_url, "Annual_Incomes", "annual_income",
                          //     incomeController);
                          staticDialigBox(
                              childController, ["0", "1", "2", "3", "4+"]);
                        },
                        child: CustomEditText(false, 15, childController,
                            TextInputType.text, "Children",
                            backgroundColor: Color(0xFFf8f8f8)),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  dialogBoxFromLocal(dynamic response, String key, String subKey,
      TextEditingController controller,
      {Map? map}) async {
    List<String> values = [];
    List<String> ids = [];

    showLoadingDialog(context, "Loading...");
    List temp = response[key] as List;
    // dynamic temp = map == null
    //     ? await getData(url, key)
    //     : await getDataPost(url, key, map);
    for (var val in temp) {
      values.add(val[subKey]);
      ids.add(val['id']);
    }
    hideLoadingDialog(context);

    _showDialog(CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 30,
      scrollController: FixedExtentScrollController(
        initialItem: 0,
      ),
      onSelectedItemChanged: (int selectedItem) {
        setState(() {
          controller.text = values[selectedItem];
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        setState(() {
          controller.text = values[0];
        });

        return Center(child: Text(values[index]));
      }),
    ));
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 265,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      decoration:
                          borderRadius(Color.fromARGB(255, 233, 233, 233), 8),
                      margin: EdgeInsets.only(right: 20),
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Done")))
                ],
              ),
            ),
            Container(height: 200, child: child),
          ],
        ),
      ),
    );
  }

  dialogBox(
      String url, String key, String subKey, TextEditingController controller,
      {Map? map}) async {
    List<String> values = [];
    List<String> ids = [];

    showLoadingDialog(context, "Loading...");
    dynamic temp = map == null
        ? await getData(url, key)
        : await getDataPost(url, key, map);
    for (var val in temp) {
      values.add(val[subKey]);
      ids.add(val['id']);
    }
    hideLoadingDialog(context);

    _showDialog(CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 30,
      scrollController: FixedExtentScrollController(
        initialItem: 0,
      ),
      onSelectedItemChanged: (int selectedItem) {
        setState(() {
          controller.text = values[selectedItem];
          // if (key == "Countries") {
          //   stateController.text = "";
          //   cityController.text = "";
          //   selectedCountryId = ids[selectedItem];
          //   selectedStateId = 0;
          // }
          // if (controller == stateController) {
          //   cityController.text = "";
          //   selectedStateId = ids[selectedItem];
          // }
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        return Center(child: Text(values[index]));
      }),
    ));
  }

  staticDialigBox(TextEditingController controller, List values) {
    _showDialog(CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 30,
      scrollController: FixedExtentScrollController(
        initialItem: 0,
      ),
      onSelectedItemChanged: (int selectedItem) {
        setState(() {
          controller.text = values[selectedItem];
          // if (key == "Countries") {
          //   stateController.text = "";
          //   cityController.text = "";
          //   selectedCountryId = ids[selectedItem];
          //   selectedStateId = 0;
          // }
          // if (controller == stateController) {
          //   cityController.text = "";
          //   selectedStateId = ids[selectedItem];
          // }
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        return Center(child: Text(values[index]));
      }),
    ));
  }

  GetValues getValues = new GetValues();

  getData(String url, String keyword) async {
    dynamic responseData = await getValues.get(url);
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);
      return responseData[keyword];
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  getDataPost(String url, String keyword, Map map) async {
    dynamic responseData = await getValues.getValues(url, map);
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);

      return responseData[keyword];
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  progress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: borderRadius(primaryColor, 20),
              child: Center(
                child: Text(
                  "1",
                  style: TextStyle(color: white, fontSize: 15),
                ),
              ),
            ),
            Container(height: 1, width: 70, color: primaryColor),
            Container(
              height: 40,
              width: 40,
              decoration: borderRadius(primaryColor, 20),
              child: Center(
                child: Text(
                  "2",
                  style: TextStyle(color: white, fontSize: 15),
                ),
              ),
            ),
            Container(height: 1, width: 70, color: primaryColor),
            Container(
              height: 40,
              width: 40,
              decoration: borderRadius(primaryColor, 20),
              child: Center(
                child: Text(
                  "3",
                  style: TextStyle(color: white, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "We are almost done.",
          style: TextStyle(
              color: primaryColor, fontSize: 16, fontFamily: "medium"),
        ),
      ],
    );
  }

  Auth auth = new Auth();
  dynamic values;
  bool isValidEmail = true;
  submitForm() async {
    if (maritalController.text == "" ||
        toungueController.text == "" ||
        religionController.text == "" ||
        castController.text == "" ||
        manglikController.text == "" ||
        horoscopeController.text == "") {
      showToast("Please fill all fields");
      return;
    }
    Map mapToSend = {
      "marital_status": maritalController.text,
      "mother_tongue": toungueController.text,
      "religion": religionController.text,
      "cast": castController.text,
      "is_manglik": manglikController.text,
      "horoscope_needed": horoscopeController.text,
      "no_of_child": maritalController.text == "Never Married" ||
              childController.text == ""
          ? "0"
          : childController.text,
      "user_id": await getString(key: userId),
      "profile_completed": "30"
    };
    loadingState(true);
    dynamic responseData = await auth.signupStepFour(mapToSend);
    print(responseData);

    if (responseData['success']) {
      values = responseData['user'];
      loginRequest();
      //Navigator.pop(context);

      print(values);
      // loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong while signup. Please try again later");
    }
  }

  loginRequest() async {
    loadingState(true);
    String? emailSaved = await getString(key: email);
    String? passwordSaved = await getString(key: password);
    dynamic responseData = await auth.login({
      "username": emailSaved,
      "password": passwordSaved,
      "google_token": ""
    });
    dynamic data = responseData['user'];

    if (responseData['success']) {
      setValueBool(isLoggedIn, true);
      setValue(userId, data['id']);
      setValue(username, emailSaved!);
      setValue(password, passwordSaved!);
      setValue(email, data['email']);
      setValue(mobileNumber, data['mobile_number']);
      setValue(fullName, data['full_name']);
      setValue(gender, data['gender']);
      setValue(photo, data['photo']);
      setValue(profileId, data['profile_id']);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignupUploadPic()));

      loadingState(false);
    } else {
      loadingState(false);
      showToast(
          "Username or password wrong. Please check you credentials and check again");
    }
  }
}
