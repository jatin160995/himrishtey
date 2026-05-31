import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';

class EditContact extends StatefulWidget {
  const EditContact({super.key});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alternatePhoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = userInfo['mobile_number'];
    whatsappController.text = userInfo['whatsapp_number'];
    emailController.text = userInfo['email'];
    alternatePhoneController.text = userInfo['alternate_number'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Edit Contact info"),
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
          SizedBox(height: 10),
          smallHeading("Phone number *"),
          CustomEditText(
              false, 15, phoneController, TextInputType.text, "Phone number",
              backgroundColor: Color(0xFFf8f8f8), length: 13),
          smallHeading("Alternate Phone number"),
          CustomEditText(!isLoading, 15, alternatePhoneController,
              TextInputType.phone, "Alternate Phone number",
              backgroundColor: Color(0xFFf8f8f8), length: 13),
          SizedBox(height: 10),
          smallHeading("WhatsApp number"),
          CustomEditText(!isLoading, 15, whatsappController,
              TextInputType.phone, "WhatsApp number",
              backgroundColor: Color(0xFFf8f8f8), length: 13),
          SizedBox(height: 10),
          smallHeading("Email Id *"),
          CustomEditText(
              false, 15, emailController, TextInputType.text, "Email Id",
              backgroundColor: Color(0xFFf8f8f8)),
        ],
      ),
    );
  }

  //// Save Value
  GetValues getValues = new GetValues();
  bool isLoading = false;
  saveData() async {
    if (phoneController.text == "" || emailController.text == "") {
      showSnackBar(context, "Please fill the required fields. Marked with *.");
      return;
    }
    if (phoneController.text.length < 10 || phoneController.text.length > 13) {
      showSnackBar(context, "Please enter the valid phone number.");
      return;
    }
    if (alternatePhoneController.text.isNotEmpty) {
      if ((phoneController.text.length < 10 ||
          phoneController.text.length > 13)) {
        showSnackBar(context, "Please enter the valid alternate phone number.");
        return;
      }
    }

    showLoadingDialog(context, "Saving data...");

    dynamic responseData = await getValues.getValues(update_profile_url, {
      "user_id": userInfo['id'],
      "mobile_number": phoneController.text,
      "email": emailController.text,
      "whatsapp_number": whatsappController.text,
      "alternate_number": alternatePhoneController.text,
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
