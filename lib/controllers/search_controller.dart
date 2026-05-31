import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/variables/api_endpoints.dart';

class SearchProfileController extends ChangeNotifier {
  bool isLoading = false;
  Future<Map<String, dynamic>> searchProfileById(String profileId) async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.post(Uri.parse(search_by_id_url),
        body: {"profile_id": profileId, "user_id": user_id});
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> quickSearch(Map mapToSend) async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response =
        await http.post(Uri.parse(quick_search_url), body: mapToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }
}
