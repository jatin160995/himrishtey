import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/button_loader.dart';
//import 'package:url_launcher/url_launcher.dart';

class RateUs extends StatefulWidget {
  const RateUs({super.key});

  @override
  State<RateUs> createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  double rating = 0.0;
  TextEditingController textEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PannableRatingBar(
          rate: rating,
          items: List.generate(
              5,
              (index) => const RatingWidget(
                    selectedColor: Colors.yellow,
                    unSelectedColor: Colors.grey,
                    child: Icon(
                      Icons.star,
                      size: 48,
                    ),
                  )),
          onChanged: (value) {
            // the rating value is updated on tap or drag.

            setState(() {
              rating = value;
            });
            if (rating > 3) {
              if (Platform.isAndroid || Platform.isIOS) {
                final appId = Platform.isAndroid
                    ? 'com.app.himrishtey'
                    : 'com.app.himrishtey';
                final url = Uri.parse(
                  Platform.isAndroid
                      ? "market://details?id=$appId"
                      : "https://apps.apple.com/app/id$appId",
                );
                Navigator.pop(context);
                // launchUrl(
                //   url,
                //   mode: LaunchMode.externalApplication,
                // );
                setValueBool(isRatingAdded, true);
              }
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
        Card(
          child: Container(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: textEditingController,
              maxLines: 5, //or null
              decoration:
                  InputDecoration.collapsed(hintText: "Enter your text here"),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            width: double.infinity,
            decoration: borderRadius(primaryColor, 8),
            child: TextButton(
                onPressed: () {
                  isLoading
                      ? null
                      : getDataPost(
                          add_rating_url, rating, textEditingController.text);
                },
                child: isLoading
                    ? ButtonLoader()
                    : Text(
                        "Submit",
                        style: TextStyle(color: white, fontFamily: "medium"),
                      )))
      ],
    );
  }

  GetValues getValues = new GetValues();
  bool isLoading = false;
  getDataPost(String url, double rating, String desc) async {
    if (rating == 0) {
      showToast("Please select rating");
      return;
    }
    if (desc.trim() == "") {
      showToast("Please add description");
      return;
    }
    loadingState(true);
    Map mapToSend = {
      'name': await getString(key: fullName),
      'profile_id': await getString(key: profileId),
      'email': await getString(key: email),
      'rating': rating.toString(),
      'description': desc.toString(),
    };
    dynamic responseData = await getValues.getValues(url, mapToSend);

    if (responseData['success']) {
      loadingState(false);
      showToast("Rating submitted");
      setValueBool(isRatingAdded, true);
      Navigator.pop(context);
      return responseData;
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
