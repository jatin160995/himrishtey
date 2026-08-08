import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/user_controller.dart';
import 'package:himrishtey/screens/auth/sigup_success.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/image_watermark.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:image_cropper/image_cropper.dart';
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

  // Holds the cropped result. Null until the user finishes (or cancels)
  // a crop, in which case the original picked image is shown/used instead.
  File? croppedImage;
  bool isCropping = false;

  File get activeImageFile => croppedImage ?? File(widget.image.path);

  @override
  void initState() {
    super.initState();
    // Auto-launch the cropper the moment this screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openCropper(isInitial: true);
    });
  }

  Future<void> _openCropper({bool isInitial = false}) async {
    setState(() {
      isCropping = true;
    });

    // Always crop from the ORIGINAL picked image (never from a previously
    // cropped copy) so re-adjusting the crop never compounds quality loss.
    final CroppedFile? result = await ImageCropper().cropImage(
      sourcePath: widget.image.path,
      maxWidth: 1080,
      maxHeight: 1080,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 50,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Photo',
          toolbarColor: primaryColor,
          toolbarWidgetColor: white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Adjust Photo',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (result != null) {
      setState(() {
        croppedImage = File(result.path);
        isCropping = false;
      });
    } else {
      setState(() {
        isCropping = false;
      });
      if (isInitial) {
        showToast("You can adjust the crop anytime using the crop icon.");
      }
    }
  }

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
    final double avatarSize = MediaQuery.of(context).size.width * 0.6;

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
            onPressed: (isLoading || isCropping)
                ? null
                : () {
                    uploadPhotoToServer();
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
              Stack(
                children: [
                  Container(
                    decoration: borderRadius(
                      white,
                      MediaQuery.of(context).size.width * 0.3,
                    ),
                    clipBehavior: Clip.antiAlias,
                    margin: EdgeInsets.all(20),
                    child: Stack(
                      children: [
                        Image.file(
                          activeImageFile,
                          height: avatarSize,
                          width: avatarSize,
                          fit: BoxFit.cover,
                        ),
                        if (isCropping)
                          Container(
                            height: avatarSize,
                            width: avatarSize,
                            color: Colors.black26,
                            child: Center(
                              child: CircularProgressIndicator(color: white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 24,
                    bottom: 24,
                    child: GestureDetector(
                      onTap: isCropping ? null : () => _openCropper(),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: white, width: 2),
                        ),
                        child: Icon(Icons.crop, color: white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  convertTo64() async {
    final File fileData = activeImageFile;
    final Uint8List imageBytes = await fileData.readAsBytes();

    final Uint8List watermarkedBytes = await addDiagonalTextWatermark(
      imageBytes,
      _watermarkText(),
    );

    return base64Encode(watermarkedBytes);
  }

  // Brand-aware text, matching the pattern already used in
  // utils/common.dart (imageUrlPrefix()) and screens/auth/login.dart.
  String _watermarkText() {
    return isHimrishtey == 1
        ? "HimRishtey"
        : isHimrishtey == 2
            ? "DevbhoomiRishtey"
            : "Dogri Rishtey";
  }

  UserController userController = new UserController();
  uploadPhotoToServer() async {
    loadingState(true);
    print("upload");

    dynamic responseData =
        await userController.uploadProfilePic(await convertTo64());

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

  bool isLoading = false;

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
