import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:http/http.dart' as http;
import '../utils/variables/api_endpoints.dart';

class UserController extends ChangeNotifier {
  bool isLoading = false;
  Future<Map<String, dynamic>> uploadProfilePic(String base64) async {
    isLoading = true;
    var user_id = await getString(key: userId);
    print(user_id);

    final response = await http.post(Uri.parse(upload_profile_pic),
        body: {"user_id": user_id, "image": base64});
    print(json.decode(response.body).toString());

    if (response.statusCode == 200) {
      isLoading = false;

      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"status": false};
    }
  }

  Future<Map<String, dynamic>> shortListProfile(
      String profileId, String url) async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.post(Uri.parse(url),
        body: {"user_id": user_id, "profile_id": profileId});
    print(json.decode(response.body).toString());

    if (response.statusCode == 200) {
      isLoading = false;

      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getMembership() async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.get(
      Uri.parse(get_memberships_url),
    );
    print(json.decode(response.body).toString());

    if (response.statusCode == 200) {
      isLoading = false;

      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getMembershipPlans(String id) async {
    isLoading = true;
    final response = await http.post(Uri.parse(get_memberships_plans_url),
        body: {'membership_id': id});
    print(json.decode(response.body).toString());
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }
}
