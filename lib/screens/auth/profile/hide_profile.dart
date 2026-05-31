import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';

class HideProfile extends StatefulWidget {
  const HideProfile({super.key});

  @override
  State<HideProfile> createState() => _HideProfileState();
}

List days = [7, 15, 30, 90];

class _HideProfileState extends State<HideProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Hide Profile"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            "Select the days from the following list. After you press submit, your profile will be hidden for the selected period of time. It will not be visible for the any of the HimRishtey user.",
            style: TextStyle(color: textMedium(), fontSize: 16),
          ),
          Divider(
            height: 40,
            color: darkLightText,
          ),
          heading("Select the number of days"),
          SizedBox(height: 10),
          Column(
            children: daysWidget(),
          ),
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
                      "Submit",
                      style: TextStyle(color: white, fontSize: 16),
                    ),
            ),
          )
        ],
      ),
    );
  }

  var selectedDay = 0;

  List<Widget> daysWidget() {
    List<Widget> list = [];

    for (int i = 0; i < days.length; i++) {
      list.add(GestureDetector(
        onTap: () {
          setState(() {
            selectedDay = i;
          });
        },
        child: Container(
            height: 50,
            color: white,
            child: Row(
              children: [
                Icon(
                  selectedDay == i
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: selectedDay == i ? primaryColor : textLightest(),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    days[i].toString() + " Days",
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
    // if (selectedDay == 0) {
    //   showToast("Please select the number of days");
    //   return;
    // }
    loadingState(true);
    dynamic responseData = await auth.hideProfile({
      "user_id": await getString(key: userId),
      "days": days[selectedDay].toString(),
    });

    if (responseData['success']) {
      Navigator.pop(context);
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => Gallery(imgArr, userInfo, true)),
      // );
      showToast('Your profile is now hidden for ' +
          days[selectedDay].toString() +
          " days.");

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
