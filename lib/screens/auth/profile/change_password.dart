import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/loader.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool isLoading = false;
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Change Password"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          heading("Current password"),
          CustomEditText(
            !isLoading,
            17,
            oldPasswordController,
            TextInputType.text,
            "Enter current password",
            isPassword: true,
          ),
          savedPasswordWrong
              ? Text(
                  "Password  is incorrect",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
              : Container(),
          SizedBox(height: 20),
          heading("New password"),
          CustomEditText(
            !isLoading,
            17,
            newPasswordController,
            TextInputType.text,
            "Enter new password",
            isPassword: true,
          ),
          SizedBox(height: 20),
          heading("Confirm password"),
          CustomEditText(
            !isLoading,
            17,
            confirmPasswordController,
            TextInputType.text,
            "Confirm password",
            isPassword: true,
          ),
          SizedBox(height: 40),
          Container(
            height: 50,
            decoration: borderRadius(primaryColor, 10),
            child: TextButton(
              onPressed: () {
                updatePassword();
              },
              child: isLoading
                  ? ButtonLoader()
                  : Text(
                      "Update",
                      style: TextStyle(color: white, fontSize: 16),
                    ),
            ),
          )
        ],
      ),
    );
  }

  bool savedPasswordWrong = false;
  bool passwordNotMatched = false;

  Auth auth = new Auth();

  updatePassword() async {
    var passwordSaved = await getString(key: password);
    var userIdSaved = await getString(key: userId);
    var newPassword = newPasswordController.text;
    if (passwordSaved != oldPasswordController.text) {
      setState(() {
        savedPasswordWrong = true;
      });
      print(passwordSaved);
      showSnackBar(context, "Please fill the correct old password.");
      return;
    }
    if (newPassword.length < 8) {
      showSnackBar(context, "Password must  be at least 8 characters long");
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      setState(() {
        passwordNotMatched = true;
      });
      showSnackBar(context, "Password doesn't match");
      return;
    }
    loadingState(true);
    // return;
    dynamic responseData = await auth
        .updatePassword({'user_id': userIdSaved, 'password': newPassword});

    if (responseData['success']) {
      loadingState(false);
      setValue(password, newPassword);
      newPasswordController.text = '';
      confirmPasswordController.text = '';
      oldPasswordController.text = '';
      showSnackBar(context, "Password Updated Successfully");
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
