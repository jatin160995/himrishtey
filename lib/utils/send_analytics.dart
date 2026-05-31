import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/variables/globals.dart';

sendStats(String name, {Map<String, Object>? map}) async {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.setUserProperty(
      name: "platform", value: Platform.isIOS ? "iOS" : "Android");
  analytics.logEvent(
    name: Platform.isIOS ? name + '_ios' : name + "_android",
    parameters: map ?? <String, Object>{},
  );
  facebookAppEvents.logEvent(
    name: Platform.isIOS ? name + '_ios' : name + "_android",
    parameters: map ?? <String, Object>{},
  );
}
