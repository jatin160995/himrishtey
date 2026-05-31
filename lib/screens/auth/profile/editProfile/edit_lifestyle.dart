import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/custom_textfield_alphabet.dart';

class EditLifestyle extends StatefulWidget {
  const EditLifestyle({super.key});

  @override
  State<EditLifestyle> createState() => _EditLifestyleState();
}

class _EditLifestyleState extends State<EditLifestyle> {
  TextEditingController dietController = TextEditingController();
  TextEditingController smokingController = TextEditingController();
  TextEditingController drinkingController = TextEditingController();
  TextEditingController disabilityController = TextEditingController();
  TextEditingController disabilityController2 = TextEditingController();

  @override
  void initState() {
    dietController.text = userInfo['diet'].toString();
    smokingController.text = userInfo['is_smoking'].toString();
    drinkingController.text = userInfo['is_drinking'].toString();
    disabilityController.text = userInfo['any_disability'].toString();
    disabilityController2.text = userInfo['any_disability'].toString() == "No"
        ? ""
        : userInfo['any_disability'].toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Lifestyle"),
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
          SizedBox(height: 10),
          smallHeading("Diet"),
          GestureDetector(
            onTap: () {
              // dialogBox(income_url, "Annual_Incomes", "annual_income",
              //     incomeController);
              staticDialogBox(dietController, ["", "Veg", "Veg & Non-Veg"]);
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
              staticDialogBox(smokingController, ["", "Yes", "No"]);
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
              staticDialogBox(drinkingController, ["", "Yes", "No"]);
            },
            child: CustomEditText(
                false, 15, drinkingController, TextInputType.text, "Drinking",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Any Disability"),
          GestureDetector(
            onTap: () {
              // dialogBox(income_url, "Annual_Incomes", "annual_income",
              //     incomeController);
              staticDialogBox(disabilityController, ["", "Yes", "No"]);
            },
            child: CustomEditText(false, 15, disabilityController,
                TextInputType.text, "Any Disability",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          disabilityController.text == 'Yes'
              ? CustomEditTextAlphabet(!isLoading, 15, disabilityController2,
                  TextInputType.text, "Explain disability",
                  backgroundColor: Color(0xFFf8f8f8))
              : Container()
        ],
      ),
    );
  }

  //// Save Value
  saveData() async {
    dynamic responseData = await getValues.getValues(update_profile_url, {
      "user_id": userInfo['id'],
      "any_disability": (disabilityController.text == 'No'
          ? "No"
          : disabilityController2.text),
      "diet": dietController.text,
      "is_smoking": smokingController.text,
      "is_drinking": drinkingController.text,
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
