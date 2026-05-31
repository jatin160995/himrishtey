import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class EditPreference extends StatefulWidget {
  const EditPreference({super.key});

  @override
  State<EditPreference> createState() => _EditPreferenceState();
}

class _EditPreferenceState extends State<EditPreference> {
  SfRangeValues _ageRange = SfRangeValues(18.0, 70.0);
  SfRangeValues _heightRange = SfRangeValues(4.6, 7.0);
  SfRangeValues _incomeRange = SfRangeValues(0, 50);
  TextEditingController religionController = TextEditingController();
  TextEditingController toungueController = TextEditingController();
  TextEditingController castController = TextEditingController();
  TextEditingController manglikController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  // TextEditingController employedController = TextEditingController();
  TextEditingController dietController = TextEditingController();
  TextEditingController smokingController = TextEditingController();
  TextEditingController drinkingController = TextEditingController();
  TextEditingController maritalController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    _ageRange = SfRangeValues(
        double.parse(userInfo['partner_age_from'] == "" ||
                userInfo['partner_age_from'] == "0"
            ? "18"
            : userInfo['partner_age_from']),
        double.parse(userInfo['partner_age_to'] == "" ||
                userInfo['partner_age_to'] == "0"
            ? "70"
            : userInfo['partner_age_to']));

    _heightRange = SfRangeValues(
        double.parse(userInfo['partner_height_from'] == "" ||
                userInfo['partner_height_from'] == "0"
            ? "4.6"
            : userInfo['partner_height_from']),
        double.parse(userInfo['partner_height_to'] == "" ||
                userInfo['partner_height_to'] == "0"
            ? "7.0"
            : userInfo['partner_height_to']));

    _incomeRange = SfRangeValues(
        double.parse(userInfo['partner_annual_income_from'] == "" ||
                userInfo['partner_annual_income_from'] == "0"
            ? "0"
            : userInfo['partner_annual_income_from']),
        double.parse(userInfo['partner_annual_income_to'] == "" ||
                userInfo['partner_annual_income_to'] == "0"
            ? "50"
            : userInfo['partner_annual_income_to']));
    toungueController.text = userInfo['partner_mothertongue'];
    religionController.text = userInfo['partner_religion'];
    castController.text = userInfo['partner_cast'];
    educationController.text = userInfo['partner_education'];
    manglikController.text = userInfo['is_partner_manglik'];
    occupationController.text = userInfo['partner_occupation'];
    dietController.text = userInfo['partner_diet'];
    drinkingController.text = userInfo['is_partner_drinking'];
    smokingController.text = userInfo['is_partner_smoking'];
    maritalController.text = userInfo['looking_for'];
    aboutController.text = userInfo['about_my_partner'];
    //employedController.text = userInfo['employed_in'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Preferences"),
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
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.all(20),
            children: [
              SizedBox(height: 10),
              heading("Age (" +
                  double.parse(_ageRange.start.toString()).toStringAsFixed(0) +
                  "-" +
                  double.parse(_ageRange.end.toString()).toStringAsFixed(0) +
                  ")"),
              SfRangeSlider(
                min: 18,
                max: 70,
                values: _ageRange,
                stepSize: 1,
                interval: 5,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: primaryColor,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _ageRange = values;
                  });
                },
              ),
              SizedBox(height: 20),
              heading("Height (ft)(" +
                  double.parse(_heightRange.start.toString())
                      .toStringAsFixed(1) +
                  "-" +
                  double.parse(_heightRange.end.toString()).toStringAsFixed(1) +
                  ")"),
              SfRangeSlider(
                min: 4.6,
                max: 7.0,
                values: _heightRange,
                stepSize: 0.1,
                interval: 0.4,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: primaryColor,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _heightRange = values;
                  });
                },
              ),
              SizedBox(height: 10),
              heading("Annual Income (lpa)(" +
                  double.parse(_incomeRange.start.toString())
                      .toStringAsFixed(0) +
                  "-" +
                  double.parse(_incomeRange.end.toString()).toStringAsFixed(0) +
                  ")"),
              SfRangeSlider(
                min: 0,
                max: 50,
                values: _incomeRange,
                stepSize: 1,
                interval: 5,
                showTicks: true,
                showLabels: true,
                enableTooltip: true,
                minorTicksPerInterval: 1,
                activeColor: primaryColor,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _incomeRange = values;
                  });
                },
              ),
              SizedBox(height: 10),
              smallHeading("About my partner"),
              Container(
                decoration: borderRadius(Color(0xFFf8f8f8), 10),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextField(
                    controller: aboutController,
                    maxLines: null, //or null
                    decoration:
                        InputDecoration.collapsed(hintText: "About my partner"),
                  ),
                ),
              ),
              SizedBox(height: 10),
              smallHeading("Partner Marital Status"),
              GestureDetector(
                onTap: () {
                  multiSelectDialogBox(marital_url, "Marital_Status",
                      "marital_status", maritalController);
                  tempController = maritalController;
                },
                child: CustomEditText(false, 15, maritalController,
                    TextInputType.text, "Partner Marital Status",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              smallHeading("Religion"),
              GestureDetector(
                onTap: () {
                  multiSelectDialogBox(religion_url, "Religions", "religion",
                      religionController);
                  tempController = religionController;
                },
                child: CustomEditText(false, 15, religionController,
                    TextInputType.text, "Religion",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              smallHeading("Mother Tongue"),
              GestureDetector(
                onTap: () {
                  multiSelectDialogBox(toungue_url, "Mother_Tongues",
                      "mother_tongue", toungueController);
                  tempController = toungueController;
                },
                child: CustomEditText(false, 15, toungueController,
                    TextInputType.text, "Mother Tongue",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              smallHeading("Cast"),
              GestureDetector(
                onTap: () {
                  multiSelectDialogBox(
                      casts_url, "Casts", "cast", castController);
                  tempController = castController;
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
                  staticDialogBox(manglikController, ["Any", "Yes", "No"]);
                },
                child: CustomEditText(
                    false, 15, manglikController, TextInputType.text, "Manglik",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              smallHeading("Highest Qualification"),
              GestureDetector(
                onTap: () {
                  //  showToast("message");
                  multiSelectDialogBox(education_url, "Educations", "education",
                      educationController);
                  tempController = educationController;
                },
                child: CustomEditText(false, 15, educationController,
                    TextInputType.text, "Highest Qualification",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              smallHeading("Employed In"),
              GestureDetector(
                onTap: () {
                  //  showToast("message");
                  multiSelectDialogBox(employer_url, "Employers", "employer",
                      occupationController);
                  tempController = occupationController;
                },
                child: CustomEditText(false, 15, occupationController,
                    TextInputType.text, "Employed In",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              // smallHeading("Employed in"),
              // GestureDetector(
              //   onTap: () {
              //     //  showToast("message");
              //     multiSelectDialogBox(employer_url, "Employers", "employer",
              //         employedController);
              //     tempController = employedController;
              //   },
              //   child: CustomEditText(false, 15, employedController,
              //       TextInputType.text, "Employed in",
              //       backgroundColor: Color(0xFFf8f8f8)),
              // ),
              // SizedBox(height: 10),
              // smallHeading("Employed In"),
              // GestureDetector(
              //   onTap: () {
              //     //  showToast("message");
              //     multiSelectDialogBox(employer_url, "Employers", "employer",
              //         employedController);
              //     tempController = occupationController;
              //   },
              //   child: CustomEditText(false, 15, employedController,
              //       TextInputType.text, "Employed in",
              //       backgroundColor: Color(0xFFf8f8f8)),
              // ),
              SizedBox(height: 10),
              smallHeading("Diet"),
              GestureDetector(
                onTap: () {
                  // dialogBox(income_url, "Annual_Incomes", "annual_income",
                  //     incomeController);
                  staticDialogBox(
                      dietController, ["Any", "Veg", "Veg & Non-Veg"]);
                },
                child: CustomEditText(
                    false, 15, dietController, TextInputType.text, "Diet",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              smallHeading("Smoking"),
              GestureDetector(
                onTap: () {
                  // dialogBox(income_url, "Annual_Incomes", "annual_income",
                  //     incomeController);
                  staticDialogBox(smokingController, ["Any", "Yes", "No"]);
                },
                child: CustomEditText(
                    false, 15, smokingController, TextInputType.text, "Smoking",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
              SizedBox(height: 10),
              smallHeading("Drinking"),
              GestureDetector(
                onTap: () {
                  // dialogBox(income_url, "Annual_Incomes", "annual_income",
                  //     incomeController);
                  staticDialogBox(drinkingController, ["Any", "Yes", "No"]);
                },
                child: CustomEditText(false, 15, drinkingController,
                    TextInputType.text, "Drinking",
                    backgroundColor: Color(0xFFf8f8f8)),
              ),
            ],
          ),
          showDialog ? showCustomDialog() : Container()
        ],
      ),
    );
  }

  //// Save Value
  saveData() async {
    dynamic responseData =
        await getValues.getValues(set_partner_preferences_url, {
      "user_id": userInfo['id'],
      "partner_age_from": _ageRange.start.toString(),
      "partner_age_to": _ageRange.end.toString(),
      "partner_height_from":
          double.parse(_heightRange.start.toString()).toStringAsFixed(1),
      "partner_height_to":
          double.parse(_heightRange.end.toString()).toStringAsFixed(1),
      "partner_annual_income_from":
          double.parse(_incomeRange.start.toString()).toStringAsFixed(1),
      "partner_annual_income_to":
          double.parse(_incomeRange.end.toString()).toStringAsFixed(1),
      "partner_mothertongue": toungueController.text,
      "partner_religion": religionController.text,
      "partner_cast": castController.text,
      "partner_education": educationController.text,
      "is_partner_manglik": manglikController.text,
      "partner_occupation": occupationController.text,
      "partner_diet": dietController.text,
      "is_partner_drinking": drinkingController.text,
      "is_partner_smoking": smokingController.text,
      "looking_for": maritalController.text,
      "about_my_partner": aboutController.text,
      //"employed_in": employedController.text,
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
        });
      },
      children: List<Widget>.generate(values.length, (int index) {
        controller.text = values[0];
        return Center(child: Text(values[index]));
      }),
    ));
  }

  multiSelectDialogBox(
    String url,
    String key,
    String subKey,
    TextEditingController controller,
  ) async {
    showLoadingDialog(context, "Loading...");
    dynamic temp = await getData(url, key);
    print(temp);
    for (var val in temp) {
      setState(() {
        valuesCustomWidget.add(val[subKey]);
        idCustomWidget.add(val['id']);
      });
    }
    hideLoadingDialog(context);

    setState(() {
      showDialog = true;
    });
  }

  bool showDialog = false;
  Widget customWidget = Container();
  late TextEditingController tempController;
  List<String> valuesCustomWidget = [];
  List<String> idCustomWidget = [];
  showCustomDialog() {
    // ignore: use_build_context_synchronously
    List<Widget> childrenWidget = [];
    for (int i = 0; i < valuesCustomWidget.length; i++) {
      childrenWidget.add(GestureDetector(
        onTap: () {
          // showToast(values[index]);
          if (tempController.text == '') {
            setState(() {
              if (tempController.text
                  .split(",")
                  .contains(valuesCustomWidget[i])) {
                List finalVal = tempController.text.split(",");
                finalVal.remove(valuesCustomWidget[i]);
                tempController.text = finalVal.join(",");
                return;
              }
              tempController.text = valuesCustomWidget[i];
            });
          } else {
            setState(() {
              if (tempController.text
                  .split(",")
                  .contains(valuesCustomWidget[i])) {
                List finalVal = tempController.text.split(",");
                finalVal.remove(valuesCustomWidget[i]);
                tempController.text = finalVal.join(",");
                return;
              }
              tempController.text =
                  tempController.text + "," + valuesCustomWidget[i];
            });
          }
          // print(tempController.text.split(","));
        },
        child: Container(
          color: transparent,
          child: Row(
            children: [
              Container(
                  height: 50,
                  child: Center(
                      child: Text(
                    valuesCustomWidget[i],
                    style: TextStyle(fontSize: 19, fontFamily: 'medium'),
                  ))),
              tempController.text.split(",").contains(valuesCustomWidget[i])
                  ? Icon(
                      Icons.done,
                      color: primaryColor,
                    )
                  : Container(),
            ],
          ),
        ),
      ));
    }

    customWidget = ListView(
      children: childrenWidget,
    );
    return Stack(
      children: [
        Container(
          color: transparentBlack,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  height: 300,
                  decoration: borderRadius(white, 20),
                  width: MediaQuery.of(context).size.width - 40,
                  child: customWidget,
                ),
                Container(
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: borderRadius(white, 20),
                  clipBehavior: Clip.antiAlias,
                  child: Row(children: [
                    Expanded(
                        child: Container(
                      color: white,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            tempController.text = "";
                          });
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(fontFamily: "medium"),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      color: white,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            valuesCustomWidget.clear();
                            idCustomWidget.clear();
                            tempController = new TextEditingController();
                            showDialog = false;
                          });
                        },
                        child: Text(
                          "Done",
                          style: TextStyle(
                              color: primaryColor, fontFamily: "medium"),
                        ),
                      ),
                    )),
                  ]),
                )
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                valuesCustomWidget.clear();
                idCustomWidget.clear();
                tempController = new TextEditingController();

                showDialog = false;
              });
            },
          ),
        )
      ],
    );
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

  staticDialogBox(TextEditingController controller, List values) {
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

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
