import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/signup/signup_four.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';

class SignUpThree extends StatefulWidget {
  const SignUpThree({super.key});

  @override
  State<SignUpThree> createState() => _SignUpThreeState();
}

class _SignUpThreeState extends State<SignUpThree> {
  bool isLoading = false;
  TextEditingController educationController = TextEditingController();
  TextEditingController employedInController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

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
                    "Next >",
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
            smallHeading("Education"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(
                    educations, "Educations", "education", educationController);
              },
              child: CustomEditText(false, 15, educationController,
                  TextInputType.text, "Educations",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Employed In"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(
                    employers, "Employers", "employer", employedInController);
              },
              child: CustomEditText(false, 15, employedInController,
                  TextInputType.text, "Employed In",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            employedInController.text != "Not Employed in"
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      smallHeading("Occupation"),
                      GestureDetector(
                        onTap: () {
                          dialogBoxFromLocal(occupations, "Occupations",
                              "occupation", occupationController);
                        },
                        child: CustomEditText(false, 15, occupationController,
                            TextInputType.text, "Occupations",
                            backgroundColor: Color(0xFFf8f8f8)),
                      ),
                    ],
                  )
                : Container(),

            SizedBox(height: 10),
            smallHeading("Annual Income"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(incomes, "Annual_Incomes", "annual_income",
                    incomeController);
              },
              child: CustomEditText(false, 15, incomeController,
                  TextInputType.text, "Annual Income",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
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
        controller.text = values[0];

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
            Container(height: 1, width: 70, color: Colors.grey),
            Container(
              height: 40,
              width: 40,
              decoration: borderRadius(Colors.grey, 20),
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
          "Let us know little more about you",
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
    if (educationController.text == "" ||
        employedInController.text == "" ||
        incomeController.text == "") {
      showToast("Please fill all fields");
      return;
    }
    if (occupationController.text == "" &&
        employedInController.text != "Not Employed in") {
      showToast("Please fill all fields");
      return;
    }
    Map mapToSend = {
      "education": educationController.text,
      "employed_in": employedInController.text,
      "occupation": employedInController.text == "Not Employed in"
          ? ""
          : occupationController.text,
      "annual_income": incomeController.text,
      "user_id": await getString(key: userId),
      "profile_completed": "25"
    };
    loadingState(true);
    dynamic responseData = await auth.signupStepThree(mapToSend);
    print(responseData);

    if (responseData['success']) {
      values = responseData['user'];
      // Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpFour()));
      print(values);
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong while sigup. Please try again later");
    }
  }
}
