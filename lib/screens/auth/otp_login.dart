import 'dart:async';

import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/auth/profile/enter_forgot_password.dart';
import 'package:himrishtey/screens/dashboard.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';

import '../../utils/common.dart';
import '../../utils/container_radius.dart';
import '../../widgets/custom_edit_text.dart';

class OtpLogin extends StatefulWidget {
  int identifier; // 0 : login , 1 : forgot password, 2: Verify Mobile
  OtpLogin(this.identifier, {super.key});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController otpController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Container(
        child: ListView(
          children: [
            Stack(
              children: [
                Container(
                  //height: 130,
                  color: white,
                  child: Image.asset("assets/images/baraat.png"),
                ),
                SafeArea(
                    child: Container(
                  padding: EdgeInsets.all(10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: textDark(),
                      size: 30,
                    ),
                  ),
                )),
              ],
            ),
            Stack(
              children: [
                Container(
                  height: 50,
                  color: white,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: backgroundLight,
                  ),
                  child: isSent
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            heading("OTP sent to *******" +
                                phoneController.text.substring(
                                    phoneController.text.length - 3)),
                            SizedBox(height: 10),
                            CustomEditText(
                              !isLoading,
                              15,
                              otpController,
                              TextInputType.phone,
                              "OTP",
                              backgroundColor: white,
                              length: 4,
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            widget.identifier == 1
                                ? Column(
                                    children: [
                                      title("New password"),
                                      CustomEditText(
                                        !isLoading,
                                        15,
                                        passwordController,
                                        TextInputType.text,
                                        "New password",
                                        backgroundColor: white,
                                        length: 10,
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: borderRadius(transparent, 10),
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                width: double.infinity,
                                //decoration: defaultGradient(),
                                color: primaryColor,
                                child: TextButton(
                                  onPressed: () {
                                    widget.identifier == 1
                                        ? changePassword()
                                        : widget.identifier == 0
                                            ? verify()
                                            : verifyMobile();
                                  },
                                  child: isLoading
                                      ? ButtonLoader()
                                      : Text(
                                          "Verify",
                                          style: TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                time == 0 || timeValue.contains(time)
                                    ? Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  isSent = false;
                                                });
                                              },
                                              child: Text("Change Number")),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                sendOtp();
                                              },
                                              child: Text("Resend OTP"))
                                        ],
                                      )
                                    : Text(time.toString() +
                                        " seconds to resend OTP")
                              ],
                            )
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headingBig(widget.identifier == 0
                                ? "Login with OTP"
                                : widget.identifier == 1
                                    ? "Forgot Password"
                                    : 'Verify Mobile'),
                            SizedBox(height: 10),
                            title("Enter Phone number"),
                            CustomEditText(
                              !isSent,
                              15,
                              phoneController,
                              TextInputType.phone,
                              "Phone number",
                              backgroundColor: white,
                              length: 10,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: borderRadius(transparent, 10),
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                width: double.infinity,
                                //decoration: defaultGradient(),
                                color: primaryColor,
                                child: TextButton(
                                  onPressed: () {
                                    sendOtp();
                                  },
                                  child: isLoading
                                      ? ButtonLoader()
                                      : Text(
                                          "Send OTP",
                                          style: TextStyle(
                                              color: white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  List timeValue = [
    60,
    120,
    300,
    600,
    1800,
    3600,
  ];
  int attemptNumber = 0;

  int time = 60;
  late Timer _timer;
  startTime() {
    // time = timeValue[attemptNumber];
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (time == 0) {
          setState(() {
            timer.cancel();
            time = timeValue[++attemptNumber];
          });
        } else {
          setState(() {
            time--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  GetValues getValues = new GetValues();
  bool isLoading = false;
  bool isSent = false;
  sendOtp() async {
    if (phoneController.text.isEmpty) {
      showToast("Please enter phone number");
      return;
    }
    loadingState(true);
    dynamic responseData = await getValues.getValues(
        widget.identifier == 0
            ? otp_login_url
            : widget.identifier == 1
                ? forgot_password_url
                : verify_mobile_otp_url,
        {"mobile_number": phoneController.text});

    print(responseData.toString());

    if (responseData['Status'] == "OK") {
      // if (widget.identifier == 1) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => EnterForgotPassword()),
      //   );
      // }
      loadingState(false);
      // Navigator.pop(context, "1");
      setState(() {
        isSent = true;
        showToast('OTP sent');
        startTime();
      });
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  verify() async {
    if (otpController.text.length == 0) {
      showToast("Please enter OTP");
      return;
    }
    loadingState(true);
    dynamic responseData =
        await getValues.getValues(otp_verify_url, {"otp": otpController.text});

    print(responseData.toString());

    if (responseData['success']) {
      loadingState(false);
      // Navigator.pop(context, "1");
      var data = responseData['user'];
      setValueBool(isLoggedIn, true);
      setValue(userId, data['id']);
      setValue(username, data['email']);
      setValue(password, data['password']);
      setValue(email, data['email']);
      setValue(mobileNumber, data['mobile_number']);
      setValue(fullName, data['full_name']);
      setValue(gender, data['gender']);
      setValue(photo, data['photo']);
      setValue(profileId, data['profile_id']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    } else {
      loadingState(false);
      showToast("Wrong OTP");
      return [];
    }
  }

  verifyMobile() async {
    if (otpController.text.length == 0) {
      showToast("Please enter OTP");
      return;
    }
    loadingState(true);
    var user_id = await getString(key: userId);
    dynamic responseData = await getValues.getValues(
        verify_mobile_url, {"otp": otpController.text, "user_id": user_id});

    print(responseData.toString());

    if (responseData['success']) {
      loadingState(false);
      showToast("Mobile Verified Successfully");
      Navigator.pop(context, "1");
    } else {
      loadingState(false);
      showToast("Wrong OTP");
      return [];
    }
  }

  changePassword() async {
    if (otpController.text.length == 0) {
      showToast("Please enter OTP");
      return;
    }
    if (passwordController.text.length == 0) {
      showToast("Please enter new password");
      return;
    }
    loadingState(true);
    dynamic responseData = await getValues.getValues(forgot_password_update_url,
        {"otp": otpController.text, 'password': passwordController.text});

    print(responseData.toString());

    if (responseData['success']) {
      loadingState(false);
      // Navigator.pop(context, "1");
      showToast("Password updated successfully");

      Navigator.pop(context);
    } else {
      loadingState(false);
      showToast("Wrong OTP");
      return [];
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  Widget title(String title) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: TextStyle(color: textDark(), fontSize: 12),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}
