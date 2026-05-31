import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/user_controller.dart';
import 'package:himrishtey/screens/auth/sigup_success.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadProfilePhoto extends StatefulWidget {
  XFile image;
  bool goback;
  UploadProfilePhoto(this.image, this.goback, {super.key});

  @override
  State<UploadProfilePhoto> createState() => _UploadProfilePhotoState();
}

class _UploadProfilePhotoState extends State<UploadProfilePhoto> {
  String abc = "helo";
  DateTime? currentBackPressTime;
  bool canPopNow = false;
  int requiredSeconds = 2;

  void onPopInvoked(bool didPop) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) >
            Duration(seconds: requiredSeconds)) {
      currentBackPressTime = now;
      showToast("Press back to exit. Signup process will be terminated.");
      Future.delayed(
        Duration(seconds: requiredSeconds),
        () {
          // Disable pop invoke and close the toast after 2s timeout
          setState(() {
            canPopNow = false;
          });
        },
      );
      // Ok, let user exit app on the next back press
      setState(() {
        canPopNow = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPopNow,
      onPopInvoked: onPopInvoked,
      child: Scaffold(
        backgroundColor: backgroundColor(),
        appBar: AppBar(
          title: headingBig("Upload profile picture"),
        ),
        bottomNavigationBar: Container(
          color: primaryColor,
          child: TextButton(
            onPressed: () {
              setState(() async {
                uploadPhotoToServer();
                // await uploadImageWithProgress((progress) {
                //   print(
                //       "Upload progress: ${(progress * 100).toStringAsFixed(2)}%");
                // });
              });
            },
            child: isLoading
                ? ButtonLoader()
                : Text(
                    "Upload",
                    style: TextStyle(
                        color: white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: borderRadius(
                  white,
                  MediaQuery.of(context).size.width * 0.3,
                ),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.all(20),
                // height: MediaQuery.of(context).size.height * 0.6,
                child: Image.file(
                  height: MediaQuery.of(context).size.width * 0.6,
                  width: MediaQuery.of(context).size.width * 0.6,
                  File(widget.image.path),
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  convertTo64() async {
    File fileData = File(widget.image.path);
    List<int> imageBytes = await fileData.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  UserController userController = new UserController();
  uploadPhotoToServer() async {
    loadingState(true);
    print("upload");

    final base64Image = await convertTo64();
    // print(await convertTo64());
    dynamic responseData =
        await userController.uploadProfilePic(await convertTo64());
    // print(responseData);

    if (responseData['status']) {
      showSnackBar(context,
          "Profile photo uploaded. Photo will be visible after approval.");
      setValue(photo, responseData['image']);
      widget.goback
          ? profileRequest()
          : Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignupSuccess()),
            );
      ;
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong");
    }
  }

  Auth auth = new Auth();

  profileRequest() async {
    dynamic responseData = await auth.getProfile();
    loadingState(true);
    if (responseData['success']) {
      userInfo = responseData['data']['user'];
      userImages = responseData['images'];

      Observable.instance.notifyObservers([
        dashboard_observer,
      ],
          //notifyName: disable_home,
          map: {});
      List imgArr = [];
      for (int i = 0; i < userImages.length; i++) {
        imgArr.add(userImages[i]['images']);
      }
      Navigator.pop(context);

      showToast(
          'Profile photo uploaded. Photo will be visible after approval.');

      print(userInfo);
      loadingState(false);
    } else {
      loadingState(false);
      showToast(
          "Username or password wrong. Please check you credentials and check again");
    }
  }

  // Future<void> uploadImageWithProgress(Function(double) onProgress) async {
  //   var user_id = await getString(key: userId);
  //   final url = Uri.parse(upload_profile_pic); // Replace with your API endpoint
  //   final headers = {
  //     'Content-Type': 'application/x-www-form-urlencoded',
  //   };
  //   String image64 = await convertTo64();
  //   final body = {
  //     'user_id': user_id ?? "0",
  //     'image': image64,
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
  //     } else {
  //       print("Failed to upload image: ${responseBody.toString()}");
  //     }
  //   } catch (e) {
  //     print("Error occurred while uploading image: $e");
  //   }
  // }

  bool isLoading = false;

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
