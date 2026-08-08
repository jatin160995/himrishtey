import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/controllers/auth_controller.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/screens/gallery.dart';
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

class AddGalleryImages extends StatefulWidget {
  AddGalleryImages({super.key});

  @override
  State<AddGalleryImages> createState() => _AddGalleryImagesState();
}

class _AddGalleryImagesState extends State<AddGalleryImages> {
  XFile? image;
  String? base64Image;

  // Separate loading states so the UI can show the right message
  bool isProcessing = false; // watermarking + encoding
  bool isUploading = false; // network call

  String _statusMessage = "";

  bool get hasImage => image != null && base64Image != null;
  bool get isBusy => isProcessing || isUploading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Add Gallery Image"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildImagePicker(),
          if (_statusMessage.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildStatusRow(),
          ],
          const SizedBox(height: 24),
          _buildUploadButton(),
          const SizedBox(height: 20),
          _buildHintText(),
        ],
      ),
    );
  }

  // ─── Image picker tile ────────────────────────────────────────────────────

  Widget _buildImagePicker() {
    if (image == null) {
      return GestureDetector(
        onTap: isBusy ? null : takePhoto,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: lightBackgroundColor(),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: primaryColor.withOpacity(0.3),
              width: 1.5,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined,
                  size: 48, color: primaryColor.withOpacity(0.7)),
              const SizedBox(height: 10),
              Text(
                "Tap to choose a photo",
                style: TextStyle(
                    color: textMedium(), fontSize: 15, fontFamily: "medium"),
              ),
            ],
          ),
        ),
      );
    }

    // Image selected — show a full preview with a re-pick option
    return Stack(
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(image!.path),
                fit: BoxFit.cover,
              ),
              // Dim overlay while processing so it's clear something is happening
              if (isProcessing)
                Container(
                  color: Colors.black54,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: white),
                      const SizedBox(height: 14),
                      Text(
                        "Preparing image…",
                        style: TextStyle(
                            color: white, fontSize: 14, fontFamily: "medium"),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Re-pick button — top right corner
        if (!isBusy)
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: takePhoto,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.swap_horiz, color: white, size: 16),
                    const SizedBox(width: 4),
                    Text("Change",
                        style: TextStyle(
                            color: white, fontSize: 12, fontFamily: "medium")),
                  ],
                ),
              ),
            ),
          ),

        // Ready badge — bottom left
        if (hasImage && !isBusy)
          Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text("Ready to upload",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: "medium")),
                ],
              ),
            ),
          ),
      ],
    );
  }

  // ─── Status row (shown below image while uploading) ───────────────────────

  Widget _buildStatusRow() {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          _statusMessage,
          style: TextStyle(
              color: textMedium(), fontSize: 13, fontFamily: "medium"),
        ),
      ],
    );
  }

  // ─── Upload button ─────────────────────────────────────────────────────────

  Widget _buildUploadButton() {
    return AnimatedOpacity(
      opacity: hasImage ? 1.0 : 0.4,
      duration: const Duration(milliseconds: 250),
      child: Container(
        width: double.infinity,
        decoration: borderRadius(
            (hasImage && !isBusy) ? primaryColor : primaryColorLight, 8),
        child: TextButton(
          onPressed: (hasImage && !isBusy) ? submitData : null,
          child: isUploading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: white),
                    ),
                    const SizedBox(width: 10),
                    Text("Uploading…",
                        style: TextStyle(
                            color: white, fontFamily: 'medium', fontSize: 16)),
                  ],
                )
              : Text(
                  "Upload Photo",
                  style: TextStyle(
                      color: white, fontFamily: 'medium', fontSize: 16),
                ),
        ),
      ),
    );
  }

  // ─── Bottom hint ───────────────────────────────────────────────────────────

  Widget _buildHintText() {
    return Text(
      "Photos are reviewed before appearing on your profile.",
      textAlign: TextAlign.center,
      style:
          TextStyle(color: textLightest(), fontSize: 12, fontFamily: "poppins"),
    );
  }

  // ─── Logic ─────────────────────────────────────────────────────────────────

  // takePhoto() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? picked = await picker.pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 1200,
  //     imageQuality: 90,
  //   );
  //   if (picked == null) return;

  //   setState(() {
  //     image = picked;
  //     base64Image = null;
  //     isProcessing = true;
  //     _statusMessage = "Adding watermark…";
  //   });

  //   try {
  //     final Uint8List imageBytes = await File(picked.path).readAsBytes();
  //     final Uint8List watermarked =
  //         await addDiagonalTextWatermark(imageBytes, _watermarkText());

  //     setState(() {
  //       base64Image = base64Encode(watermarked);
  //       isProcessing = false;
  //       _statusMessage = "";
  //     });
  //   } catch (e) {
  //     setState(() {
  //       isProcessing = false;
  //       _statusMessage = "";
  //     });
  //     showToast("Failed to process image. Please try again.");
  //   }
  // }
  takePhoto() async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, imageQuality: 90);

    if (pickedFile == null) return;

    CroppedFile? cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust Photo',
          toolbarColor: primaryColor,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Adjust Photo',
        ),
      ],
    );

    if (cropped == null) return;

    setState(() {
      image = XFile(cropped.path);
      base64Image = null;
      isProcessing = true;
      _statusMessage = "Adding watermark…";
    });

    await convertTo64(image);
  }

  convertTo64(dynamic pickedImage) async {
    try {
      File fileData = File(pickedImage.path);
      Uint8List imageBytes = await fileData.readAsBytes();
      Uint8List watermarked =
          await addDiagonalTextWatermark(imageBytes, _watermarkText());

      setState(() {
        base64Image = base64Encode(watermarked);
        isProcessing = false;
        _statusMessage = "";
      });
    } catch (e) {
      setState(() {
        isProcessing = false;
        _statusMessage = "";
      });
      showToast("Failed to process image. Please try again.");
    }

    return base64Image;
  }

  GetValues getValues = GetValues();

  submitData() async {
    if (!hasImage) {
      showToast("Please select a photo first.");
      return;
    }

    setState(() {
      isUploading = true;
      _statusMessage = "Uploading to server…";
    });

    try {
      dynamic responseData = await getValues.getValues(add_gallery_url, {
        "user_id": await getString(key: userId),
        "image": base64Image!,
      });

      if (responseData['status']) {
        await profileRequest();
      } else {
        setState(() {
          isUploading = false;
          _statusMessage = "";
        });
        showToast("Something went wrong. Please try again.");
      }
    } catch (e) {
      setState(() {
        isUploading = false;
        _statusMessage = "";
      });
      showToast("Upload failed. Check your connection and try again.");
    }
  }

  String _watermarkText() {
    return isHimrishtey == 1
        ? "HimRishtey"
        : isHimrishtey == 2
            ? "DevbhoomiRishtey"
            : "Dogri Rishtey";
  }

  Auth auth = Auth();

  profileRequest() async {
    dynamic responseData = await auth.getProfile();
    if (responseData['success']) {
      userInfo = responseData['data']['user'];
      userImages = responseData['images'];

      Observable.instance.notifyObservers(
        [dashboard_observer],
        notifyName: disable_home,
        map: {},
      );

      final List imgArr = [
        for (int i = 0; i < userImages.length; i++) userImages[i]['images']
      ];

      if (mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Gallery(imgArr, userInfo, true)),
        );
        showToast('Gallery updated');
      }
    } else {
      setState(() {
        isUploading = false;
        _statusMessage = "";
      });
      showToast("Something went wrong. Please try again.");
    }
  }
}
