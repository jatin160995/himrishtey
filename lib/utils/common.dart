import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pannable_rating_bar/flutter_pannable_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:himrishtey/screens/rate_us.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:intl/intl.dart';
//FB2056

const primaryColor = Color(0xFFD92768);
const primaryColorLight = Color.fromARGB(255, 247, 107, 159);
const primaryColorPlaceholder = Color(0x90D92768);
const primaryColorTransparent = Color(0x20D92768);
//const primaryAccentTransparent = Color(0x80A2AFCF);

const secondryColor = Color(0xFFEFA994);
const backgroundDark = Color(0xFF181818);
const backgroundDark2 = Color(0xFF232323);
const backgroundLight = Color(0xFFf0f0f0);
const formBackground = Color(0xFFD7DAE1);

//
const highlightColor = Color(0x50DB372B);

//
const primaryAccent = Color.fromARGB(255, 250, 212, 219);

const appBarDark = primaryColor;
const white = Color(0xffffffff);
const background = Color(0xFFf8f8f8);
const errorColor = Color(0xffE23744);
//const darkBackground = Color(0xFFeeeeee);

const darkText = Color(0xFF232323);
const lightText = Color(0xFF545454);
const lightestText = Color(0xFF808080);
const darkLightText = Color(0xffc8c8c8);
const darkLightestText = Color(0xffaaaaaa);
const transparent = Color(0x00000000);
const transparentWhite = Color(0x30ffffff);
const transparentBlack = Color(0xa0000000);
const transparentBlack2 = Color(0x40000000);
const transparentBlackDark = Color(0xef000000);
const dividerColor = Color(0xffd8d8d8);

const darkAppBar = Color.fromARGB(255, 18, 18, 18);
const darkBackground = Color(0xFF151515);
const darkBackgroundTransparent = Color.fromARGB(174, 33, 33, 33);
const playerBackground = Color.fromARGB(255, 33, 69, 141);
const smallPlayerSecondry = Color.fromARGB(255, 123, 146, 136);
const lightBlue = Color.fromARGB(255, 185, 221, 248);
const smallPlayerSecondryTransparent = Color.fromARGB(64, 162, 142, 117);
const darkHeading = Color(0xFFACB6C7);

//Rating Colors
const one = Color(0xffE23744);
const two = Color(0xffFF7800);
const three = Color(0xffCDD614);
const four = Color(0xff91CB60);
const five = Color(0xff39B549);
const darkBlue = Color(0xff141B36);

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showToastLong(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0);
}

/*
String parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body!.text).documentElement!.text;

  return parsedString;
}
*/

//Common Image Path
String loadImgPath = "assets/images/loading.gif";
String placeholder = "assets/images/placeholder.png";
String logo = "assets/images/logo-2.png";
String icon = "assets/images/icon.png";
String logo_white = "assets/images/logo-white.png";

String currencySign = "₹";
String coinSign = "🪙";

dynamic ratingColor(double rating) {
  dynamic ratingColor;
  double ratingDouble = rating;
  if (ratingDouble == 5)
    ratingColor = five;
  else if (ratingDouble >= 4)
    ratingColor = four;
  else if (ratingDouble >= 3)
    ratingColor = three;
  else if (ratingDouble >= 2)
    ratingColor = two;
  else
    ratingColor = one;

  return ratingColor;
}

String stringToDouble(String value) {
  return double.parse(value).toStringAsFixed(2);
}

DateTime utcToLocalTime(dynamic dateStr) {
  print(dateStr + '-- utcToLocalTime');
  try {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(dateStr, true);
    //return DateTime.parse(dateStr).toLocal();
    return dateTime.toLocal();
  } catch (e) {
    var dateTime = DateFormat("yyyy-MM-dd HH:mm").parse(dateStr, true);
    //return DateTime.parse(dateStr).toLocal();
    return dateTime.toLocal();
  }
}

String utcToLocalReadableTime(dynamic dateStr) {
  print(dateStr + '-- utcToLocalReadableTime');
  final DateFormat formatter = DateFormat('hh:MM a');
  final String formatted = formatter.format(utcToLocalTime(dateStr));
  return formatted;
}

String readableDate(dynamic dateStr) {
  // final DateFormat formatter = DateFormat('dd MMMM, yyyy');
  // final String formatted = formatter.format(utcToLocalTime(dateStr));
  // return formatted;
  print(dateStr + '-- utcToLocalReadableDate');
  // DateTime now = DateTime.parse(dateStr);
  // String formattedDate = DateFormat('dd MMMM, yyyy').format(now);
  return DateFormat("dd MMMM, yyy")
      .format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateStr));
}

String readableTime(dynamic dateStr) {
  // DateTime now = DateTime.parse(dateStr);
  // String formattedDate = DateFormat('hh:mm a').format(now);
  return DateFormat("hh:mm:ss a")
      .format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateStr));
}

String timeAgo(String dateStr) {
  DateTime todayDate = new DateTime.now();
  int milisecondsAgo = todayDate.toLocal().millisecondsSinceEpoch -
      utcToLocalTime(dateStr).toLocal().millisecondsSinceEpoch;
  int secondsAgo = (milisecondsAgo / 1000).round();
  int minute = 60;
  int hour = 60 * minute;
  int day = 24 * hour;
  int week = 7 * day;

  if (secondsAgo < minute) // seconds
  {
    return "just now";
  } else if (secondsAgo < hour) // minutes
  {
    if (secondsAgo / minute == 1) {
      return (secondsAgo / minute).toStringAsFixed(0) + "m ago";
    } else {
      return (secondsAgo / minute).toStringAsFixed(0) + "m ago";
    }
  } else if (secondsAgo < day) // hours
  {
    if (secondsAgo / hour == 1) {
      return (secondsAgo / hour).toStringAsFixed(0) + "h ago";
    } else {
      return (secondsAgo / hour).toStringAsFixed(0) + "h ago";
    }
  } else if (secondsAgo < week) // days
  {
    if (secondsAgo / day == 1) {
      return (secondsAgo / day).toStringAsFixed(0) + "d ago";
    } else {
      return (secondsAgo / day).toStringAsFixed(0) + "d ago";
    }
  }
  if (secondsAgo / week == 1) {
    return (secondsAgo / week).toStringAsFixed(0) + "w ago";
  } else {
    return (secondsAgo / week).toStringAsFixed(0) + "w ago";
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

formatedTime(int timeInSecond) {
  int sec = timeInSecond % 60;
  int min = (timeInSecond / 60).floor();
  String minute = min.toString().length <= 1 ? "0$min" : "$min";
  String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
  return "$minute : $second";
}

isEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

Widget smallHeading(String title) {
  return Container(
    //margin: EdgeInsets.all(15),
    child: Text(
      title,
      style: TextStyle(
          color: textDark(), fontSize: 12, fontWeight: FontWeight.normal),
    ),
  );
}

Widget heading(String title) {
  return Container(
    //margin: EdgeInsets.all(15),
    child: Text(
      title,
      style: TextStyle(
          color: textDark(), fontSize: 17, fontWeight: FontWeight.bold),
    ),
  );
}

Widget headingBig(String title) {
  return Container(
    child: Text(
      title,
      style: TextStyle(
          color: textDark(), fontSize: 23, fontWeight: FontWeight.bold),
    ),
  );
}

// calculateAge(String dob) {
//   DateTime dt1 =
//       DateTime.parse(dob.replaceAll("AM", "").replaceAll("PM", "").trim());
//   DateTime dt2 = DateTime.now();

//   return ((dt2.difference(dt1).inDays) / 365).toStringAsFixed(0);
// }

calculateAge(String dob) {
  DateTime birthDate =
      DateTime.parse(dob.replaceAll("AM", "").replaceAll("PM", "").trim());
  DateTime today = DateTime.now();

  int age = today.year - birthDate.year;

  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }

  return age.toString();
}

dismissKeyboard(dynamic context) {
  FocusScope.of(context).unfocus();
}

Color backgroundColor() {
  return isDarkTheme ? darkBackground : white;
}

Color lightBackgroundColor() {
  return isDarkTheme ? Color(0xFF252525) : Color(0xFFF1F1F1);
}

Color darkBackgroundColor() {
  return Color(0xff110436);
}

Color textLightest() {
  return isDarkTheme ? darkLightestText : lightestText;
}

Color textMedium() {
  return isDarkTheme ? darkLightText : lightText;
}

Color textDark() {
  return isDarkTheme ? white : darkText;
}

bool isTabletView(dynamic context) {
  //var shortestSide = MediaQuery.of(context).size.shortestSide;
  var width = MediaQuery.of(context).size.width;

  return width > 600;
}

imageUrlPrefix() {
  return isHimrishtey == 1
      ? "https://himrishtey.com/photos/photo/"
      : isHimrishtey == 2
          ? "https://devbhoomirishtey.com/photos/photo/"
          : "https://dogririshtey.com/photos/photo/";
}
/*
checkIfLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  bool? loginFlag = prefs.getBool(isLoggedIn);
  //showToast(loginFlag.toString());
  bool flag = false;
  if (loginFlag.toString() == "null" || !loginFlag!) {
    flag = false;
  } else {
    flag = true;
  }
  return flag;
}*/

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

void showLoadingDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: primaryColor,
            ),
            SizedBox(height: 16.0),
            Text(
              message,
              style: TextStyle(
                  color: textDark(), fontSize: 16, fontFamily: "medium"),
            ),
          ],
        ),
      );
    },
  );
}

void showRateUsDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        title: Text("Rate Us"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [RateUs()],
        ),
      );
    },
  );
}

void showWarningDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info,
              color: Colors.amber,
              size: 50,
            ),
            Text(
              message,
              style: TextStyle(
                  color: textDark(), fontSize: 18, fontFamily: "medium"),
            ),
          ],
        ),
      );
    },
  );
}

void showSnackBar(BuildContext context, String message) {
  // final snackBar = SnackBar(
  //   content: Text(
  //     message,
  //     style: TextStyle(fontWeight: FontWeight.bold),
  //   ),
  //   duration: Duration(seconds: 4),
  //   action: SnackBarAction(
  //     label: 'OK',
  //     onPressed: () {
  //       // Some code to undo the change.
  //     },
  //   ),
  // );

  // // Find the ScaffoldMessenger in the widget tree
  // // and use it to show a SnackBar.
  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: darkText,
      textColor: Colors.white,
      fontSize: 16.0);
}

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

Future<void> showContactDialog(BuildContext context, String msg) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Contact Us'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                msg,
                style: TextStyle(
                  color: textMedium(),
                  fontSize: 14,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Contact : +91 9857102002',
                style: TextStyle(
                    color: textDark(), fontSize: 15, fontFamily: "medium"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
