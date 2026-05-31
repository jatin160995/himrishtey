import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

import '../../utils/container_radius.dart';
import '../../widgets/custom_edit_text.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController phoneController = new TextEditingController();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headingBig("Forgot Password"),
                      SizedBox(height: 10),
                      title("Enter Phone number"),
                      CustomEditText(
                        true,
                        15,
                        phoneController,
                        TextInputType.phone,
                        "Phone number",
                        backgroundColor: white,
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
                            onPressed: () {},
                            child: Text(
                              "Send OTP",
                              style: TextStyle(
                                  color: white, fontWeight: FontWeight.bold),
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
