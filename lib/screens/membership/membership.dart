import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/controllers/user_controller.dart';
import 'package:himrishtey/screens/membership/membership_ios.dart';
import 'package:himrishtey/screens/membership/membership_plans.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Membership extends StatefulWidget {
  Membership({super.key});

  @override
  State<Membership> createState() => _MembershipState();
}

class _MembershipState extends State<Membership> {
  @override
  void initState() {
    getPlans();
    _checkCallbackStatus();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Membership"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          isLoading
              ? Loader()
              // : Platform.isIOS
              //     ? Column(
              //         children: [
              //           Text(
              //             "To activate this functionality contact us.",
              //             style: TextStyle(color: textMedium()),
              //           ),
              //           Text(
              //             "Contact : +91 9857102002",
              //             style: TextStyle(
              //                 color: textDark(),
              //                 fontSize: 20,
              //                 fontFamily: "medium"),
              //           )
              //         ],
              //       )
              //     :
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !isPlanActivated
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Plan Expired",
                                style: TextStyle(
                                    color: textDark(),
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Your plan has been expired. Please activate your membership from following options.",
                                style: TextStyle(
                                    color: textMedium(), fontSize: 13),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          )
                        : Container(),
                    heading("Plans"),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: planWidgets(),
                    )
                  ],
                ),
          Divider(
            color: dividerColor,
            height: 60,
          ),
          headingBig("Need a discussion?"),
          SizedBox(
            height: 15,
          ),
          Container(
            decoration:
                borderRadius(_canRequest ? primaryColorLight : lightestText, 8),
            child: TextButton(
              onPressed: () {
                !_canRequest ? null : getData(callback_number_url);
              },
              child: isLoadingCallback
                  ? ButtonLoader()
                  : Text(
                      _canRequest
                          ? "Request a callback"
                          : "Please wait before requesting again.",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: textDark(),
                    size: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    _formatDuration(_remaining),
                    style: TextStyle(
                        color: textDark(),
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(
                  "Need a discussion, press the button above and we will contact you within 10 minutes.",
                  style: TextStyle(
                      height: 1.2,
                      color: textLightest(),
                      fontWeight: FontWeight.normal,
                      //fontFamily: "medium",
                      fontSize: 12),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  //  GetValues getValues = new GetValues();
  // bool isLoading = false;
  // bool isSent = false;
  // sendOtp() async {
  //   loadingState(true);
  //   dynamic responseData = await getValues
  //       .getValues(otp_login_url, {"mobile_number": phoneController.text});

  //   print(responseData.toString());

  //   if (responseData['Status'] == "OK") {
  //     loadingState(false);
  //     // Navigator.pop(context, "1");
  //     setState(() {
  //       isSent = true;
  //       showToast('OTP sent');
  //       startTime();
  //     });
  //   } else {
  //     loadingState(false);
  //     showToast("Something went wrong");
  //     return [];
  //   }
  // }

  Future<void> _checkCallbackStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTime = prefs.getString("callbackRequestTimeKey");
    print(storedTime);
    if (storedTime == null) {
      setState(() {
        _canRequest = true;
      });
      return;
    }
    final storedDateTime = DateTime.parse(storedTime);
    final now = DateTime.now();
    final diff = now.difference(storedDateTime);

    if (diff.inMinutes >= 10) {
      setState(() {
        _canRequest = true;
      });
    } else {
      setState(() {
        _canRequest = false;
        _remaining = Duration(minutes: 10) - diff;
      });
      _startTimer();
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  bool _canRequest = true;
  GetValues getValues = new GetValues();
  Duration _remaining = Duration.zero;
  Timer? _timer;

  getData(String url) async {
    dynamic responseData = await getValues.get(url);
    loadingCallbackState(true);
    if (responseData['success']) {
      loadingCallbackState(false);
      // showToast(responseData['number']['number'].toString());
      sendOtp(responseData['number']['number']);
    } else {
      loadingCallbackState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  sendOtp(String number) async {
    loadingCallbackState(true);
    dynamic responseData = await getValues.getValues(callback_url, {
      'user_id': userInfo['id'],
      'user_name': userInfo['full_name'],
      "number": number
    });

    print(responseData.toString());

    if (responseData['Status'] == "OK") {
      loadingCallbackState(false);
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      await prefs.setString("callbackRequestTimeKey", now.toIso8601String());
      setState(() {
        _canRequest = false;
        _remaining = Duration(minutes: 10);
      });

      _startTimer();
      showToast("You will receive a callback within 10 minutes.");
      // Navigator.pop(context, "1");
    } else {
      loadingCallbackState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  // int totalTimer = 600;
  // late Timer _timer;
  // int _start = 600;

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = new Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           _start = totalTimer;
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_remaining.inSeconds > 1) {
        setState(() {
          _remaining = _remaining - Duration(seconds: 1);
        });
      } else {
        _timer?.cancel();
        setState(() {
          _canRequest = true;
          _remaining = Duration.zero;
        });
      }
    });
  }

  List<Widget> planWidgets() {
    List<Widget> widgets = [];
    for (int i = 0; i < data.length; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            // showToast("message");
            //  planDetailDialog(data[i]);
            Platform.isIOS
                ? Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp(data)),
                  )
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MembershipPlans(data[i])),
                  );
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              gradient: LinearGradient(
                  colors: [
                    const Color(0xFFf3f3f3),
                    Color.fromARGB(255, 251, 245, 225),
                  ],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data[i]['membership_name'],
                  style: TextStyle(
                      color: textDark(),
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  data[i]['plan_description'],
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: textLightest(),
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  UserController userController = new UserController();
  bool isLoading = true;
  bool isLoadingCallback = false;
  List data = [];
  getPlans() async {
    loadingState(true);
    dynamic responseData = await userController.getMembership();
    print(responseData);
    if (responseData['success']) {
      data = responseData['memberships'];
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  loadingCallbackState(bool state) {
    setState(() {
      isLoadingCallback = state;
    });
  }

  planDetailDialog(dynamic planDetail) {
    showDialog(
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: white,
            contentPadding: EdgeInsets.only(left: 25, right: 25),
            title: Center(child: Text(planDetail['membership_name'])),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
              padding: EdgeInsets.only(bottom: 10),
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    heading("Description"),
                    Text(planDetail['plan_description']),
                    SizedBox(height: 10),
                    heading("Terms and Conditions"),
                    Text(planDetail['terms_and_conditions']),
                    SizedBox(height: 10),
                    heading("Features"),
                    Text("● " + planDetail['tag_line1'].toString()),
                    Text("● " + planDetail['tag_line2'].toString()),
                    Text("● " + planDetail['tag_line3'].toString()),
                    Text("● " + planDetail['tag_line4'].toString()),
                    Text("● " + planDetail['tag_line5'].toString()),
                    Text("● " + planDetail['tag_line6'].toString()),
                  ],
                ),
              ),
            ),
          );
        },
        context: context);
  }
}
