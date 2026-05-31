import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/variables/observer_variables.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:http/http.dart' as http;
import '../utils/variables/api_endpoints.dart';

class InterestController extends ChangeNotifier {
  bool isLoading = false;
  Future<Map<String, dynamic>> getInterests() async {
    isLoading = true;
    var _userId = await getString(key: userId);

    final response = await http
        .post(Uri.parse(get_interests_url), body: {"user_id": _userId});
    if (response.statusCode == 200) {
      isLoading = false;
      Observable.instance.notifyObservers(
          [
            interests_observer,
          ],
          notifyName: interests_updater,
          map: {});
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false, "message": "No profiles found"};
    }
  }

  Future<Map<String, dynamic>> sendInterests(String profile_id) async {
    isLoading = true;
    var _userId = await getString(key: userId);

    final response = await http.post(Uri.parse(send_interests_url),
        body: {"user_id": _userId, "profile_id": profile_id});
    if (response.statusCode == 200) {
      isLoading = false;
      Observable.instance.notifyObservers(
          [
            interests_observer,
          ],
          notifyName: interests_updater,
          map: {});
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false, "message": "Something wend wrong"};
    }
  }

  Future<Map<String, dynamic>> acceptInterests(
      String profile_id, String status) async {
    isLoading = true;
    var _userId = await getString(key: userId);

    final response = await http.post(Uri.parse(accept_interests_url),
        body: {"user_id": _userId, "profile_id": profile_id, 'status': status});
    if (response.statusCode == 200) {
      isLoading = false;
      Observable.instance.notifyObservers(
          [
            interests_observer,
          ],
          notifyName: interests_updater,
          map: {});
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false, "message": "Something wend wrong"};
    }
  }

  Future<Map<String, dynamic>> deleteInterests(String profile_id) async {
    isLoading = true;
    var _userId = await getString(key: userId);

    final response = await http.post(Uri.parse(delete_interests_url), body: {
      "user_id": _userId,
      "profile_id": profile_id,
    });
    if (response.statusCode == 200) {
      isLoading = false;
      Observable.instance.notifyObservers(
          [
            interests_observer,
          ],
          notifyName: interests_updater,
          map: {});
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false, "message": "Something wend wrong"};
    }
  }
}
