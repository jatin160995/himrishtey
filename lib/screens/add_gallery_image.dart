import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/gallery.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddGalleryImages extends StatefulWidget {
  AddGalleryImages({super.key});

  @override
  State<AddGalleryImages> createState() => _AddGalleryImagesState();
}

class _AddGalleryImagesState extends State<AddGalleryImages> {
  TextEditingController imageController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Add Gallery Images"),
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
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 40),
            decoration: borderRadius(primaryColor, 8),
            child: TextButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        submitData();
                        // await uploadImageWithProgress((progress) {
                        //   print(
                        //       "Upload progress: ${(progress * 100).toStringAsFixed(2)}%");
                        // });
                      },
                child: isLoading
                    ? ButtonLoader()
                    : Text(
                        "Upload",
                        style: TextStyle(
                            color: white, fontFamily: 'medium', fontSize: 16),
                      )),
          )
        ],
      ),
    );
  }

  GetValues getValues = new GetValues();
  submitData() async {
    if (imageController.text == "") {
      showSnackBar(context, "Please fill all the fields");
      return;
    }
    loadingState(true);
    dynamic responseData = await getValues.getValues(add_gallery_url, {
      "user_id": await getString(key: userId),
      "image": imageController.text,
    });

    print(responseData.toString());

    if (responseData['status']) {
      // loadingState(false);
      profileRequest();
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  // Future<void> uploadImageWithProgress(Function(double) onProgress) async {
  //   var userid = await getString(key: userId);
  //   final url = Uri.parse(add_gallery_url); // Replace with your API endpoint
  //   final headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //   };
  //   final body = {
  //     'user_id': userid ?? "0",
  //     'image': imageController.text,
  //   };

  //   try {
  //     final client = http.Client();
  //     final request = http.Request("POST", url)
  //       ..headers.addAll(headers)
  //       ..bodyFields = body;

  //     final streamedResponse = await client.send(request);

  //     final totalBytes = streamedResponse.contentLength ?? 0;
  //     double uploadedBytes = 0;

  //     // Listen to the stream for progress
  //     final responseBody = StringBuffer();
  //     await for (var chunk in streamedResponse.stream) {
  //       uploadedBytes += chunk.length;
  //       onProgress(uploadedBytes / totalBytes);

  //       // Collect the response body
  //       responseBody.write(utf8.decode(chunk));
  //     }

  //     // Check the response status code
  //     if (streamedResponse.statusCode == 200) {
  //       print("Image uploaded successfully: ${responseBody.toString()}");
  //       profileRequest();
  //     } else {
  //       print("Failed to upload image: ${responseBody.toString()}");
  //     }
  //   } catch (e) {
  //     print("Error occurred while uploading image: $e");
  //   }
  // }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  XFile? image;
  takePhoto() async {
    ImagePicker picker = ImagePicker();
    image = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, imageQuality: 90);
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

  Auth auth = new Auth();

  profileRequest() async {
    dynamic responseData = await auth.getProfile();
    loadingState(true);
    if (responseData['success']) {
      userInfo = responseData['data']['user'];
      userImages = responseData['images'];

      Observable.instance.notifyObservers(
          [
            dashboard_observer,
          ],
          notifyName: disable_home,
          map: {});
      List imgArr = [];
      for (int i = 0; i < userImages.length; i++) {
        imgArr.add(userImages[i]['images']);
      }
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Gallery(imgArr, userInfo, true)),
      );
      showToast('Gallery updated');

      print(userInfo);
      loadingState(false);
    } else {
      loadingState(false);
      showToast(
          "Username or password wrong. Please check you credentials and check again");
    }
  }
}
