library jagran.application.globals;

import 'package:facebook_app_events/facebook_app_events.dart';

final facebookAppEvents = FacebookAppEvents();
//General
bool isConnected = false;
bool isDarkTheme = false;
bool isCurrentlyLogin = false;
bool isPlanActivated = true;
int? isHimrishtey = 1; // 1 - himrishtey, 2= devbhoomi, 3= dogri

//Home
int screenIndex = 0;

//User Variables
String userFullName = "";
String profilePhoto = "";

// Temp Variables
dynamic userInfo = {};
List userImages = [];

// Server Values
dynamic heights;
dynamic countries;
dynamic educations;
dynamic employers;
dynamic occupations;
dynamic incomes;
dynamic maritals;
dynamic toungues;
dynamic religions;
dynamic casts;
