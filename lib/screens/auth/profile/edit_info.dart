import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:intl/intl.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  bool isLoading = false;
  TextEditingController profileCreatedForController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController tobController = TextEditingController();
  TextEditingController religionController = TextEditingController();
  TextEditingController castController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController maritalController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController childController = TextEditingController();

  dynamic selectedCountryId = 0;
  dynamic selectedStateId = 0;

  @override
  void initState() {
    super.initState();

    String dob = userInfo['birth_date_time'].toString().split(" ")[0];
    String tob = userInfo['birth_date_time']
        .toString()
        .split(" ")
        .sublist(1)
        .join(' ')
        .trim();
    profileCreatedForController.text = userInfo['profile_created_for'];
    aboutController.text = userInfo['about_me'];
    dobController.text = dob;
    tobController.text = tob;
    religionController.text = userInfo['religion'];
    castController.text = userInfo['cast'];
    cityController.text = userInfo['city_living_in'];
    stateController.text = userInfo['state_living_in'];
    countryController.text = userInfo['country_living_in'];
    maritalController.text = userInfo['marital_status'];
    heightController.text = userInfo['height'];
    childController.text =
        userInfo['no_of_child'] == null ? "0" : userInfo['no_of_child'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Basic Info"),
        actions: [
          Container(
            decoration: borderRadius(primaryAccent, 10),
            margin: EdgeInsets.only(right: 10),
            height: 38,
            child: TextButton(
                onPressed: () async {
                  showLoadingDialog(context, "Saving data...");
                  await saveData();
                  hideLoadingDialog(context);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.save,
                      color: textDark(),
                      size: 22,
                    ),
                    SizedBox(width: 5),
                    Text("Save",
                        style: TextStyle(
                            color: textDark(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold))
                  ],
                )),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          smallHeading("About"),
          Container(
            decoration: borderRadius(Color(0xFFf8f8f8), 10),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: aboutController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                ],
                //maxLines: 8, //or null
                decoration: InputDecoration.collapsed(hintText: "About me"),
              ),
            ),
          ),
          SizedBox(height: 10),
          smallHeading("Profile Created By"),
          GestureDetector(
            onTap: () {
              //  showToast("message");
              dialogBox(profile_for_url, "user", "value",
                  profileCreatedForController);
            },
            child: CustomEditText(false, 15, profileCreatedForController,
                TextInputType.text, "Profile Created By",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Date of Birth"),
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
              dialogBox(heights_url, "Heights", "height", heightController);
            },
            child: CustomEditText(
                false, 15, heightController, TextInputType.text, "Height",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          smallHeading("Religion"),
          GestureDetector(
            onTap: () {
              dialogBox(
                  religion_url, "Religions", "religion", religionController);
            },
            child: CustomEditText(
                false, 15, religionController, TextInputType.text, "Religion",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          SizedBox(height: 10),
          smallHeading("Cast"),
          GestureDetector(
            onTap: () {
              dialogBox(casts_url, "Casts", "cast", castController);
            },
            child: CustomEditText(
                false, 15, castController, TextInputType.text, "Cast",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Marital Status"),
          GestureDetector(
            onTap: () {
              dialogBox(marital_url, "Marital_Status", "marital_status",
                  maritalController);
            },
            child: CustomEditText(false, 15, maritalController,
                TextInputType.text, "Marital Status",
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
              : Container(),
          SizedBox(height: 10),
          smallHeading("Country"),
          GestureDetector(
            onTap: () {
              dialogBox(countries_url, "Countries", "name", countryController);
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
    );
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

  //// Save Value
  saveData() async {
    dynamic responseData = await getValues.getValues(update_profile_url, {
      "user_id": userInfo['id'],
      "profile_created_for": profileCreatedForController.text,
      "date_of_birth": dobController.text,
      "time_of_birth": tobController.text,
      "religion": religionController.text,
      "community": castController.text,
      "country_living_in": countryController.text,
      "state_living_in": stateController.text,
      "city_living_in": cityController.text,
      "about_me": aboutController.text,
      "marital_status": maritalController.text,
      "height": heightController.text,
      "no_of_child": maritalController.text == "Never Married" ||
              childController.text == ""
          ? "0"
          : childController.text,
    });
    print({
      "profile_created_for": profileCreatedForController.text,
      "date_of_birth": dobController.text,
      "time_of_birth": tobController.text,
      "religion": religionController.text,
      "community": castController.text,
      "country_living_in": countryController.text,
      "state_living_in": stateController.text,
      "city_living_in": cityController.text,
      "about_me": aboutController.text,
    });
    print(responseData.toString());
    loadingState(true);
    if (responseData['success']) {
      loadingState(false);
      Navigator.pop(context, "1");
      showToast(
          'Profile Updated Successfully. Changes will be visible after approval.');
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    var date = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(1947, 8),
      lastDate: DateTime((date.year - 18), date.month, date.day),
      initialDate:
          DateFormat("yyyy-MM-dd hh:mm:ss").parse(userInfo['birth_date_time']),
    );
    NumberFormat formatter = new NumberFormat("00");
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
