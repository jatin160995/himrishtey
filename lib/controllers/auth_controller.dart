import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:http/http.dart' as http;
import '../utils/variables/api_endpoints.dart';

class Auth extends ChangeNotifier {
  bool isLoading = false;
  Future<Map<String, dynamic>> login(Map dataToSend) async {
    isLoading = true;
    final response = await http.post(Uri.parse(login_url), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.get(
      Uri.parse(get_profile_url + user_id.toString()),
    );
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.get(
      Uri.parse(get_stats_url + user_id.toString()),
    );
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getConfigs() async {
    isLoading = true;

    final response = await http.get(
      Uri.parse(configs_url),
    );
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getOtherProfile(String profile_id) async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.post(Uri.parse(get_other_profile_url),
        body: {"user_id": user_id, "profile_id": profile_id});
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    isLoading = true;
    var user_id = await getString(key: userId);
    final response = await http.post(Uri.parse(get_other_profile_url),
        body: {"user_id": "20", "profile_id": user_id.toString()});
    print(response.statusCode.toString() + "-----userID");
    print(user_id.toString() + "-----userID");
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  // Signup 1
  Future<Map<String, dynamic>> signupStepOne(Map dataToSend) async {
    isLoading = true;
    final response = await http.post(
        Uri.parse(Platform.isIOS ? signup_step_one_ios : signup_step_one),
        body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return json.decode(response.body);
    }
  }

  // Signup 2
  Future<Map<String, dynamic>> signupStepTwo(Map dataToSend) async {
    isLoading = true;
    final response =
        await http.post(Uri.parse(signup_step_two), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  // Signup 3
  Future<Map<String, dynamic>> signupStepThree(Map dataToSend) async {
    isLoading = true;
    final response =
        await http.post(Uri.parse(signup_step_three), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  // Signup 4
  Future<Map<String, dynamic>> signupStepFour(Map dataToSend) async {
    isLoading = true;
    final response =
        await http.post(Uri.parse(signup_step_four), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  // Signup 4
  Future<Map<String, dynamic>> updatePassword(Map dataToSend) async {
    isLoading = true;
    final response =
        await http.post(Uri.parse(reset_password_url), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  //
  Future<Map<String, dynamic>> deleteProfile(Map dataToSend) async {
    isLoading = true;
    final response =
        await http.post(Uri.parse(delete_profile_url), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return json.decode(response.body);
    }
  }

  // Signup 4
  Future<Map<String, dynamic>> hideProfile(Map dataToSend) async {
    isLoading = true;
    final response =
        await http.post(Uri.parse(hide_profile_url), body: dataToSend);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return json.decode(response.body);
    }
  }

  logout() async {
    setValueBool(isLoggedIn, false);
    setValue(userId, "");
    setValue(username, "");
    setValue(password, "");
    setValue(email, "");
    setValue(mobileNumber, "");
    setValue(fullName, "");
    setValue(gender, "");
    setValue(photo, "");
  }
}
