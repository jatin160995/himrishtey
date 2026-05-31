import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';

class EnterForgotPassword extends StatefulWidget {
  const EnterForgotPassword({super.key});

  @override
  State<EnterForgotPassword> createState() => _EnterForgotPasswordState();
}

class _EnterForgotPasswordState extends State<EnterForgotPassword> {
  bool isLoading = false;
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLight,
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(20),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headingBig("Enter new password and OTP"),
                SizedBox(height: 10),
                title("New password"),
                CustomEditText(
                  !isLoading,
                  15,
                  passwordController,
                  TextInputType.phone,
                  "New password",
                  backgroundColor: white,
                  length: 10,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
