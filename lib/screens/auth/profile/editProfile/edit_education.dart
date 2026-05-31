import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/custom_textfield_alphabet.dart';

class EditEducation extends StatefulWidget {
  const EditEducation({super.key});

  @override
  State<EditEducation> createState() => _EditEducationState();
}

class _EditEducationState extends State<EditEducation> {
  TextEditingController educationController = TextEditingController();
  TextEditingController otherQualificationController = TextEditingController();
  TextEditingController employedController = TextEditingController();
  TextEditingController occupationController = TextEditingController();
  TextEditingController workingController = TextEditingController();
  TextEditingController jobLocationController = TextEditingController();
  TextEditingController organizationController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    educationController.text = userInfo['education'].toString();
    otherQualificationController.text =
        userInfo['any_other_qualifications'].toString();
    employedController.text = userInfo['employed_in'].toString();
    occupationController.text = userInfo['occupation'].toString();
    jobLocationController.text = userInfo['job_location'].toString();
    organizationController.text = userInfo['organization_name'].toString();
    incomeController.text = userInfo['annual_income'].toString();
    aboutController.text = userInfo['about_my_education'].toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Education"),
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
          smallHeading("About my career & Education"),
          CustomEditTextAlphabet(!isLoading, 15, aboutController,
              TextInputType.text, "About my career & Education",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Education"),
          GestureDetector(
            onTap: () {
              //  showToast("message");
              dialogBox(education_url, "Educations", "education",
                  educationController);
            },
            child: CustomEditText(
                false, 15, educationController, TextInputType.text, "Education",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Other Qualification"),
          CustomEditTextAlphabet(!isLoading, 15, otherQualificationController,
              TextInputType.text, "Other Qualification",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Employed in"),
          GestureDetector(
            onTap: () {
              //  showToast("message");
              dialogBox(
                  employer_url, "Employers", "employer", employedController);
            },
            child: CustomEditText(false, 15, employedController,
                TextInputType.text, "Employed in",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Occupation"),
          GestureDetector(
            onTap: () {
              //  showToast("message");
              dialogBox(occupations_url, "Occupations", "occupation",
                  occupationController);
            },
            child: CustomEditText(false, 15, occupationController,
                TextInputType.text, "Occupation",
                backgroundColor: Color(0xFFf8f8f8)),
          ),
          SizedBox(height: 10),
          smallHeading("Job Location"),
          CustomEditTextAlphabet(!isLoading, 15, jobLocationController,
              TextInputType.text, "Job Location",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Organization name"),
          CustomEditTextAlphabet(!isLoading, 15, organizationController,
              TextInputType.text, "Organization name",
              backgroundColor: Color(0xFFf8f8f8)),
          SizedBox(height: 10),
          smallHeading("Annual Income"),
          GestureDetector(
            onTap: () {
              dialogBox(income_url, "Annual_Incomes", "annual_income",
                  incomeController);
            },
            child: CustomEditText(false, 15, incomeController,
                TextInputType.text, "Annual Income",
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
      "any_other_qualifications": otherQualificationController.text,
      "employed_in": employedController.text,
      "occupation": occupationController.text,
      "education": educationController.text,
      "job_location": jobLocationController.text,
      "organization_name": organizationController.text,
      "annual_income": incomeController.text,
      "about_my_education": aboutController.text,
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
