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

class EditReligion extends StatefulWidget {
  const EditReligion({super.key});

  @override
  State<EditReligion> createState() => _EditReligionState();
}

class _EditReligionState extends State<EditReligion> {
  TextEditingController subCommunityController = TextEditingController();
  TextEditingController gotraController = TextEditingController();

  @override
  void initState() {
    gotraController.text = userInfo['gotra'];
    subCommunityController.text = userInfo['sub_cast'];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Religion info"),
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
                TitleText("Community", userInfo['cast']),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => EditInfo()),
                      );
                    },
                    child: Text("To edit community, Click here >"))
              ],
            ),
          ),
          //SizedBox(height: 10),
          // smallHeading("Cast"),
          // GestureDetector(
          //   onTap: () {
          //     dialogBox(casts_url, "Casts", "cast", subCommunityController);
          //   },
          //   child: CustomEditText(
          //       false, 15, subCommunityController, TextInputType.text, "Cast",
          //       backgroundColor: Color(0xFFf8f8f8)),
          // ),
          SizedBox(height: 10),
          smallHeading("Gotra *"),
          Container(
            decoration: borderRadius(Color(0xFFf8f8f8), 10),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: gotraController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                ],
                //maxLines: 8, //or null
                decoration: InputDecoration.collapsed(hintText: "Gotra"),
              ),
            ),
          ),

          SizedBox(height: 10),
          smallHeading("Sub Community"),
          Container(
            decoration: borderRadius(Color(0xFFf8f8f8), 10),
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextField(
                controller: subCommunityController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]")),
                ],
                //maxLines: 8, //or null
                decoration:
                    InputDecoration.collapsed(hintText: "Sub Community"),
              ),
            ),
          ),

          SizedBox(height: 10),
        ],
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

  //// Save Value
  bool isLoading = false;
  saveData() async {
    if (gotraController.text == "") {
      showSnackBar(context, "Please fill the required fields. Marked with *.");
      return;
    }
    showLoadingDialog(context, "Saving data...");

    dynamic responseData = await getValues.getValues(update_profile_url, {
      "user_id": userInfo['id'],
      "gotra": gotraController.text,
      "sub_community": subCommunityController.text,
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

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
