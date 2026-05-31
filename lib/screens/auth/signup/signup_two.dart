import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/signup/signup_three.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:intl/intl.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({super.key});

  @override
  State<SignUpTwo> createState() => _SignUpTwoState();
}

class _SignUpTwoState extends State<SignUpTwo> {
  bool isLoading = false;
  TextEditingController profileCreatedForController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController tobController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController castController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

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
  void initState() {
    // TODO: implement initState
    super.initState();
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
            // smallHeading("About"),
            // Container(
            //   decoration: borderRadius(Color(0xFFf8f8f8), 10),
            //   child: Padding(
            //     padding: EdgeInsets.all(15.0),
            //     child: TextField(
            //       controller: aboutController,
            //       //maxLines: 8, //or null
            //       decoration: InputDecoration.collapsed(hintText: "About me"),
            //     ),
            //   ),
            // ),
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
            smallHeading("Date of Birth (must be 18+ years old)"),
            GestureDetector(
              onTap: () {
                _selectDate(context);
              },
              child: CustomEditText(
                  false, 15, dobController, TextInputType.text, "Date of Birth",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Time of Birth"),
            GestureDetector(
              onTap: () {
                _selectTime(context);
              },
              child: CustomEditText(
                  false, 15, tobController, TextInputType.text, "Time of Birth",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("Height"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(
                    heights, "Heights", "height", heightController);
              },
              child: CustomEditText(
                  false, 15, heightController, TextInputType.text, "Height",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            // SizedBox(height: 10),
            // smallHeading("Religion"),
            // GestureDetector(
            //   onTap: () {
            //     dialogBox(
            //         religion_url, "Religions", "religion", religionController);
            //   },
            //   child: CustomEditText(
            //       false, 15, religionController, TextInputType.text, "Religion",
            //       backgroundColor: Color(0xFFf8f8f8)),
            // ),
            SizedBox(height: 10),
            // smallHeading("Cast"),
            // GestureDetector(
            //   onTap: () {
            //     dialogBox(casts_url, "Casts", "cast", castController);
            //   },
            //   child: CustomEditText(
            //       false, 15, castController, TextInputType.text, "Cast",
            //       backgroundColor: Color(0xFFf8f8f8)),
            // ),
            // SizedBox(height: 10),
            smallHeading("Country"),
            GestureDetector(
              onTap: () {
                dialogBoxFromLocal(
                    countries, "Countries", "name", countryController);
              },
              child: CustomEditText(
                  false, 15, countryController, TextInputType.text, "Country",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("State"),
            GestureDetector(
              onTap: () {
                dialogBox(state_url, "States", "name", stateController,
                    map: {"country_id": selectedCountryId});
              },
              child: CustomEditText(
                  false, 15, stateController, TextInputType.text, "State",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
            SizedBox(height: 10),
            smallHeading("City"),
            GestureDetector(
              onTap: () {
                dialogBox(city_url, "States", "name", cityController,
                    map: {"state_id": selectedStateId});
              },
              child: CustomEditText(
                  false, 15, cityController, TextInputType.text, "City",
                  backgroundColor: Color(0xFFf8f8f8)),
            ),
          ],
        ),
      ),
    );
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

  dialogBoxFromLocal(dynamic response, String key, String subKey,
      TextEditingController controller,
      {Map? map}) async {
    List<String> values = [];
    List<String> ids = [];

    if (controller == stateController && selectedCountryId == 0) {
      showSnackBar(context, "Please select country");
      return;
    }
    if (controller == cityController && selectedStateId == 0) {
      showSnackBar(context, "Please select State");
      return;
    }
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

    if (controller == cityController) {
      controller.text =
          values[0]; // Setting city by default in case of Union Territory
    }
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
          if (key == "Countries") {
            stateController.text = "";
            cityController.text = "";
            selectedCountryId = ids[selectedItem];
            selectedStateId = 0;
          }
          if (controller == stateController) {
            cityController.text = "";
            selectedStateId = ids[selectedItem];
          }
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        if (key == "Countries") {
          selectedCountryId = ids[0];
        }
        if (controller == stateController) {
          selectedStateId = ids[0];
        }
        return Center(child: Text(values[index]));
      }),
    ));
  }

  dialogBox(
      String url, String key, String subKey, TextEditingController controller,
      {Map? map}) async {
    List<String> values = [];
    List<String> ids = [];

    if (controller == stateController && selectedCountryId == 0) {
      showSnackBar(context, "Please select country");
      return;
    }
    if (controller == cityController && selectedStateId == 0) {
      showSnackBar(context, "Please select State");
      return;
    }
    showLoadingDialog(context, "Loading...");
    dynamic temp = map == null
        ? await getData(url, key)
        : await getDataPost(url, key, map);
    for (var val in temp) {
      values.add(val[subKey]);
      ids.add(val['id']);
    }
    hideLoadingDialog(context);

    if (controller == cityController) {
      controller.text =
          values[0]; // Setting city by default in case of Union Territory
    }
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
          if (key == "Countries") {
            stateController.text = "";
            cityController.text = "";
            selectedCountryId = ids[selectedItem];
            selectedStateId = 0;
          }
          if (controller == stateController) {
            cityController.text = "";
            selectedStateId = ids[selectedItem];
          }
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        if (key == "Countries") {
          selectedCountryId = ids[0];
        }
        if (controller == stateController) {
          selectedStateId = ids[0];
        }
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
            Container(height: 1, width: 70, color: Colors.grey),
            Container(
              height: 40,
              width: 40,
              decoration: borderRadius(Colors.grey, 20),
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
          "Add some information about yourself",
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
    if (dobController.text == "" ||
        tobController.text == "" ||
        heightController.text == "" ||
        stateController.text == "" ||
        cityController.text == "" ||
        countryController.text == "") {
      showToast("Please fill all fields");
      return;
    }
    Map mapToSend = {
      "date_of_birth": dobController.text,
      "time_of_birth": tobController.text,
      "height": heightController.text,
      "country": countryController.text,
      "state": stateController.text,
      "city": cityController.text,
      "user_id": await getString(key: userId),
      "profile_completed": "30"
    };
    print(mapToSend);
    loadingState(true);
    dynamic responseData = await auth.signupStepTwo(mapToSend);
    print(responseData);

    if (responseData['success']) {
      values = responseData['user'];
      // Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUpThree()));
      print(values);
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong while sigup. Please try again later");
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    var date = DateTime.now();
    NumberFormat formatter = new NumberFormat("00");
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(date.year - 18, date.month, date.day),
        firstDate: DateTime(1947, 8),
        lastDate: DateTime(date.year - 18, date.month, date.day));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = selectedDate.year.toString() +
            '-' +
            (formatter.format(selectedDate.month)).toString() +
            "-" +
            (formatter.format(selectedDate.day)).toString();
      });
    }
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime =
        await showTimePicker(context: context, initialTime: selectedTime);
    NumberFormat formatter = new NumberFormat("00");
    if (pickedTime != null && pickedTime != selectedTime)
      setState(() {
        selectedTime = pickedTime;
        tobController.text = (formatter.format(selectedTime.hour)).toString() +
            ":" +
            formatter.format(selectedTime.minute).toString() +
            ":00";
      });
  }
}
