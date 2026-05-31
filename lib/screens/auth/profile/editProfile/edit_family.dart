import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/custom_textfield_alphabet.dart';

class EditFamily extends StatefulWidget {
  const EditFamily({super.key});

  @override
  State<EditFamily> createState() => _EditFamilyState();
}

class _EditFamilyState extends State<EditFamily> {
  TextEditingController aboutFamilyTypeController = TextEditingController();
  TextEditingController familyTypeController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController motherOccupationController = TextEditingController();
  TextEditingController brothersController = TextEditingController();
  TextEditingController marriedBrothersController = TextEditingController();
  TextEditingController sistersController = TextEditingController();
  TextEditingController marriedSistersController = TextEditingController();
  TextEditingController nativePlaveController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();

  @override
  void initState() {
    aboutFamilyTypeController.text = userInfo['about_family'];
    familyTypeController.text = userInfo['family_status'];
    occupationController.text = userInfo['father_occupation'];
    motherOccupationController.text = userInfo['mother_occupation'];
    brothersController.text = userInfo['no_of_brothers'];
    sistersController.text = userInfo['no_of_sisters'];
    marriedBrothersController.text = userInfo['married_brothers'];
    sistersController.text = userInfo['married_sisters'];
    nativePlaveController.text = userInfo['native_place'];
    fatherNameController.text = userInfo['father_name'];
    motherNameController.text = userInfo['mother_name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Family details"),
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
          smallHeading("About my family"),
          CustomEditTextAlphabet(!isLoading, 15, aboutFamilyTypeController,
              TextInputType.text, "About my family",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Family Status"),
          GestureDetector(
            onTap: () {
              //  showToast("message");
              dialogBox(
                  family_url, "family_status", "value", familyTypeController);
            },
            child: CustomEditText(false, 15, familyTypeController,
                TextInputType.text, "Family Status",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Native Place"),
          CustomEditTextAlphabet(!isLoading, 15, nativePlaveController,
              TextInputType.text, "Native Place",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Father Name"),
          CustomEditTextAlphabet(!isLoading, 15, fatherNameController,
              TextInputType.text, "Father Name",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Father Occupation"),
          CustomEditTextAlphabet(!isLoading, 15, occupationController,
              TextInputType.text, "Father Occupation",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Mother Name"),
          CustomEditTextAlphabet(!isLoading, 15, motherNameController,
              TextInputType.text, "Mother Name",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Mother Occupation"),
          CustomEditTextAlphabet(!isLoading, 15, motherOccupationController,
              TextInputType.text, "Mother Occupation",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Brothers"),
          GestureDetector(
            onTap: () {
              // dialogBox(income_url, "Annual_Incomes", "annual_income",
              //     incomeController);
              staticDialogBox(
                  brothersController, ["0", "1", "2", "3", "4", "5+"]);
            },
            child: CustomEditText(
                false, 15, brothersController, TextInputType.text, "Brothers",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Married Brothers"),
          GestureDetector(
            onTap: () {
              // dialogBox(income_url, "Annual_Incomes", "annual_income",
              //     incomeController);
              staticDialogBox(
                  marriedBrothersController, ["0", "1", "2", "3", "4", "5+"]);
            },
            child: CustomEditText(false, 15, marriedBrothersController,
                TextInputType.text, "Married Brothers",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Sisters"),
          GestureDetector(
            onTap: () {
              // dialogBox(income_url, "Annual_Incomes", "annual_income",
              //     incomeController);
              staticDialogBox(
                  sistersController, ["0", "1", "2", "3", "4", "5+"]);
            },
            child: CustomEditText(
                false, 15, sistersController, TextInputType.text, "Sisters",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Married Sisters"),
          GestureDetector(
            onTap: () {
              // dialogBox(income_url, "Annual_Incomes", "annual_income",
              //     incomeController);
              staticDialogBox(
                  marriedSistersController, ["0", "1", "2", "3", "4", "5+"]);
            },
            child: CustomEditText(false, 15, marriedSistersController,
                TextInputType.text, "Married  Sisters",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
        ],
      ),
    );
  }

  //// Save Value
  saveData() async {
    dynamic responseData = await getValues.getValues(update_profile_url, {
      "user_id": userInfo['id'],
      "father_name": fatherNameController.text,
      "father_occupation": occupationController.text,
      "mother_name": motherNameController.text,
      "mother_occupation": motherOccupationController.text,
      "no_of_brothers": brothersController.text,
      "no_of_sisters": sistersController.text,
      "married_brothers": marriedBrothersController.text,
      "married_sisters": marriedSistersController.text,
      "family_status": familyTypeController.text,
      "native_place": nativePlaveController.text,
      "about_family": aboutFamilyTypeController.text,
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
