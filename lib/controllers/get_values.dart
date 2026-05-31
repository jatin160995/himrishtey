import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:http/http.dart' as http;

class GetValues extends ChangeNotifier {
  bool isLoading = false;
  final List _values = [
    {"url": heights_url, "is_get": true},
    {"url": countries_url, "is_get": true},
    {"url": education_url, "is_get": true},
    {"url": employer_url, "is_get": true},
    {"url": occupations_url, "is_get": true},
    {"url": income_url, "is_get": true},
    {"url": marital_url, "is_get": true},
    {"url": toungue_url, "is_get": true},
    {"url": religion_url, "is_get": true},
    {"url": casts_url, "is_get": true},
  ];

  getallValues() async {
    for (int i = 0; i < _values.length; i++) {
      if (_values[i]['is_get']) {
        if (_values[i]['url'] == heights_url) {
          heights = await get(_values[i]['url']);
        } else if (_values[i]['url'] == countries_url) {
          countries = await get(_values[i]['url']);
        } else if (_values[i]['url'] == education_url) {
          educations = await get(_values[i]['url']);
        } else if (_values[i]['url'] == employer_url) {
          employers = await get(_values[i]['url']);
        } else if (_values[i]['url'] == occupations_url) {
          occupations = await get(_values[i]['url']);
        } else if (_values[i]['url'] == income_url) {
          incomes = await get(_values[i]['url']);
        } else if (_values[i]['url'] == marital_url) {
          maritals = await get(_values[i]['url']);
        } else if (_values[i]['url'] == toungue_url) {
          toungues = await get(_values[i]['url']);
        } else if (_values[i]['url'] == religion_url) {
          religions = await get(_values[i]['url']);
        } else if (_values[i]['url'] == casts_url) {
          casts = await get(_values[i]['url']);
        }
      }
    }

    print("hello---" + heights.toString());
    print("hello---" + countries.toString());
    print("hello---" + educations.toString());
    print("hello---" + employers.toString());
    print("hello---" + occupations.toString());
    print("hello---" + incomes.toString());
    print("hello---" + maritals.toString());
    print("hello---" + toungues.toString());
    print("hello---" + religions.toString());
    print("hello---" + casts.toString());
  }

  dialogBox(String url, {Map? map}) async {}

  Future<Map<String, dynamic>> get(String url) async {
    isLoading = true;
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return {"success": false};
    }
  }

  Future<Map<String, dynamic>> getValues(String url, Map mapToSend) async {
    isLoading = true;
    print(url);
    final response = await http.post(Uri.parse(url), body: mapToSend);
    print(response.body);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return json.decode(response.body);
    }
  }

  Future<Map<String, dynamic>> advancedSearch(String url, Map mapToSend) async {
    isLoading = true;
    print(url);
    print(mapToSend);
    final response =
        await http.post(Uri.parse(advance_search_url), body: mapToSend);
    print(response.body);
    if (response.statusCode == 200) {
      isLoading = false;
      return json.decode(response.body);
    } else {
      isLoading = false;
      return json.decode(response.body);
    }
  }
}
