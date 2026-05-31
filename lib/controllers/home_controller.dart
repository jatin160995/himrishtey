import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/variables/api_endpoints.dart';

class HomeController extends ChangeNotifier {
  bool isLoading = false;
  Future<Map<String, dynamic>> getProfiles(String url, String page) async {
    isLoading = true;
    var user_id = await getString(key: userId);
    var genders = await getString(key: gender);
    final response = await http.post(Uri.parse(url),
        body: {"gender": genders, "user_id": user_id, 'page_no': page});
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false, "message": "No profiles found"};
    }
  }
}
