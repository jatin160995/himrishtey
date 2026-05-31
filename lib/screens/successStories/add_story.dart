import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:image_picker/image_picker.dart';

class AddStory extends StatefulWidget {
  const AddStory({super.key});
  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  bool isLoading = false;
  TextEditingController imageController = TextEditingController();
  TextEditingController groomController = TextEditingController();
  TextEditingController brideController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Add your story"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () {
              takePhoto();
            },
            child: Container(
              decoration: borderRadius(
                  imageController.text == ""
                      ? Color(0xFFF1F1F1)
                      : const Color.fromRGBO(200, 230, 201, 1),
                  8),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
              child: Row(
                children: [
                  imageController.text == ""
                      ? Container()
                      : Container(
                          height: 40,
                          child: Image.file(File(image!.path)),
                        ),
                  Text(imageController.text == ""
                      ? "Add image +"
                      : "   Image Selected  "),
                  imageController.text == ""
                      ? Container()
                      : Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          CustomEditText(!isLoading, 15, groomController, TextInputType.text,
              "Enter groom's name"),
          SizedBox(height: 10),
          CustomEditText(!isLoading, 15, brideController, TextInputType.text,
              "Enter bride's name"),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF1F1F1),
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: TextField(
              // enabled: !isLoading,
              controller: descriptionController,
              minLines: 3,
              maxLines: 1000,
              style: TextStyle(fontSize: 15),
              decoration:
                  new InputDecoration.collapsed(hintText: 'Write your story'),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: borderRadius(primaryColor, 8),
            child: TextButton(
              onPressed: () {
                submitData();
              },
              child: isLoading
                  ? ButtonLoader()
                  : Text(
                      "Post",
                      style: TextStyle(
                          color: white, fontFamily: 'medium', fontSize: 16),
                    ),
            ),
          )
        ],
      ),
    );
  }

//// Save Value
  GetValues getValues = new GetValues();
  submitData() async {
    if (groomController.text == "" ||
        brideController.text == "" ||
        descriptionController.text == "" ||
        imageController.text == "") {
      showSnackBar(context, "Please fill all the fields");
      return;
    }
    loadingState(true);
    dynamic responseData = await getValues.getValues(add_success_stories_url, {
      "user_id": await getString(key: userId),
      "groom_name": groomController.text,
      "bride_name": brideController.text,
      "image": imageController.text,
      "description": descriptionController.text,
    });

    print(responseData.toString());

    if (responseData['status']) {
      loadingState(false);
      Navigator.pop(context, "1");
      showSnackBar(context,
          'Thanks, your story has been submitted. It will be reviewed and published soon.');
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

  XFile? image;
  takePhoto() async {
    ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      convertTo64(image);
    }
    print(image?.path);
  }

  convertTo64(dynamic image) async {
    File fileData = File(image.path);
    List<int> imageBytes = await fileData.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    setState(() {
      imageController.text = base64Image;
    });

    return base64Image;
  }
}
