import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/profile/edit_info.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/title_text.dart';
import 'package:intl/intl.dart';

class EditAstro extends StatefulWidget {
  const EditAstro({super.key});

  @override
  State<EditAstro> createState() => _EditAstroState();
}

class _EditAstroState extends State<EditAstro> {
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController manglikController = TextEditingController();

  dynamic selectedCountryId = 0;
  dynamic selectedStateId = 0;

  @override
  void initState() {
    manglikController.text = userInfo['manglik'];
    cityController.text = userInfo['birth_place'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Astro & Kundli"),
        actions: [
          Container(
            decoration: borderRadius(primaryAccent, 10),
            margin: EdgeInsets.only(right: 10),
            height: 38,
            child: TextButton(
                onPressed: () async {
                  await saveData();
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
          Container(
            padding: EdgeInsets.all(20),
            decoration: borderRadius(background, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                    "Date of birth", readableDate(userInfo['birth_date_time'])),
                SizedBox(height: 10),
                TitleText("Time of birth  ",
                    readableTime(userInfo['birth_date_time'])),
                SizedBox(height: 5),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => EditInfo()),
                      );
                    },
                    child: Text("To edit date and time, Click here >"))
              ],
            ),
          ),
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
          // SizedBox(height: 10),
          // smallHeading("Country of birth"),
          // GestureDetector(
          //   onTap: () {
          //     dialogBox(countries_url, "Countries", "name", countryController);
          //   },
          //   child: CustomEditText(
          //       false, 15, countryController, TextInputType.text, "Country",
          //       backgroundColor: Color(0xFFf8f8f8)),
          // ),
          // SizedBox(height: 10),
          // smallHeading("State of birth"),
          // GestureDetector(
          //   onTap: () {
          //     dialogBox(state_url, "States", "name", stateController,
          //         map: {"country_id": selectedCountryId});
          //   },
          //   child: CustomEditText(
          //       false, 15, stateController, TextInputType.text, "State",
          //       backgroundColor: Color(0xFFf8f8f8)),
          // ),
          SizedBox(height: 10),
          smallHeading("Place of birth"),
          // GestureDetector(
          //   onTap: () {
          //     dialogBox(city_url, "States", "name", cityController,
          //         map: {"state_id": selectedStateId});
          //   },
          // child:
          Container(
            decoration: borderRadius(Color(0xFFf8f8f8), 10),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: cityController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                ],
                //maxLines: 8, //or null
                decoration: InputDecoration.collapsed(hintText: "Place"),
              ),
            ),
          ),

          //  ),
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
  bool isLoading = false;
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
    // if (cityController.text == "") {
    //   showSnackBar(context, "Select City");
    //   return;
    // }
    showLoadingDialog(context, "Saving data...");

    dynamic responseData = await getValues.getValues(update_profile_url, {
      "user_id": userInfo['id'],
      "birth_place": cityController.text,
      "manglik": manglikController.text,
    });
    hideLoadingDialog(context);
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
}
