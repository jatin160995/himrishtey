import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';

class DeleteProfile extends StatefulWidget {
  const DeleteProfile({super.key});

  @override
  State<DeleteProfile> createState() => _DeleteProfileState();
}

class _DeleteProfileState extends State<DeleteProfile> {
  TextEditingController reasonController = TextEditingController();
  List reasons = [
    "Getting Married",
    "Found match on himrishtey.com",
    "Found my match elsewhere",
    "Unsatisfactory expierience",
    "Other"
  ];
  int selectedReason = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Delete Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            "After pressing delete button your profile would be permanently deleted. All matches you've looked, connected or contated & chat history will be deleted.",
            style: TextStyle(color: textMedium(), fontSize: 16),
          ),
          SizedBox(height: 20),
          Column(
            children: resonsWidget(),
          ),
          SizedBox(height: 20),
          selectedReason == 4
              ? Container(
                  decoration: borderRadius(Color(0xFFf8f8f8), 10),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextField(
                      controller: reasonController,
                      maxLines: null, //or null
                      decoration: InputDecoration.collapsed(
                          hintText: "Describe reason"),
                    ),
                  ),
                )
              : Container(),
          SizedBox(height: 20),
          Container(
            height: 50,
            decoration: borderRadius(primaryColor, 10),
            child: TextButton(
              onPressed: () {
                deleteRequest();
              },
              child: isLoading
                  ? ButtonLoader()
                  : Text(
                      "Delete",
                      style: TextStyle(color: white, fontSize: 16),
                    ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> resonsWidget() {
    List<Widget> list = [];

    for (int i = 0; i < reasons.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedReason = i;
          });
        },
        child: Container(
            height: 50,
            color: white,
            child: Row(
              children: [
                Icon(
                  selectedReason == i
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selectedReason == i ? primaryColor : textLightest(),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    reasons[i],
                    style: TextStyle(
                        color: textDark(), fontSize: 16, fontFamily: "medium"),
                  ),
                )
              ],
            )),
      ));
    }
    return list;
  }

  Auth auth = new Auth();
  bool isLoading = false;
  deleteRequest() async {
    if (selectedReason == 4 && reasonController.text == "") {
      showToast("Please enter the reason");
      return;
    }
    loadingState(true);
    dynamic responseData = await auth.deleteProfile({
      "user_id": await getString(key: userId),
      "reason":
          selectedReason == 4 ? reasonController.text : reasons[selectedReason],
    });

    if (responseData['success']) {
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Gallery(imgArr, userInfo, true)),
      // );
      showToast(
          'Your request to delete profile has been submitted successfully');

      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong, please try again after some time");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
