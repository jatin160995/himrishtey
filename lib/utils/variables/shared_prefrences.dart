import 'package:shared_preferences/shared_preferences.dart';

String isLoggedIn = "isLoggedIn";
String isHimrishteyShared = "isHimrishtey";
// User auth
String userId = "userId";
String gender = "gender";
String username = "username";
String password = "password";
String fullName = "fullName";
String email = "email";
String mobileNumber = "mobileNumber";
String profileId = "profileId";
String photo = "photo";

// rating
String isRatingAdded = "isRatingAdded";
String lastPopupDate = "lastPopupDate";

Future setValue(String key, String val) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, val);
}

Future setValueBool(String key, bool val) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, val);
}

Future<String?> getString({String? key}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  return prefs.getString(key!);
}
