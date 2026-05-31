import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/send_analytics.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/globals.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class SearchResultPage extends StatefulWidget {
  Map searchMap;
  List searchList;
  SearchResultPage(this.searchMap, this.searchList, {super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List profileArray = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // Send stats to firebase and Pixel
    sendStats("search_result", map: {'event': 'search_result'});
    super.initState();
    getSearchedData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //print("scroll end");
        // widget.indentifier == 2 ? getData() :
        getSearchedData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor(),
        appBar: AppBar(
          title: headingBig("Search result"),
        ),
        body: Stack(
          children: [
            isLoading && page != 1
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      color: transparentBlack,
                      child: Center(
                        child: Text(
                          "Loading...",
                          style: TextStyle(
                              color: white, fontFamily: "medium", fontSize: 15),
                        ),
                      ),
                    ),
                  )
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 90),
              child: isLoading && page == 1
                  ? Loader()
                  : GridView.count(
                      controller: _scrollController,
                      primary: false,
                      padding: EdgeInsets.only(
                          left: 7, right: 7, top: 7, bottom: 70),
                      childAspectRatio: (1 / 1.25),
                      crossAxisSpacing: 7,
                      mainAxisSpacing: 5,
                      crossAxisCount: 2,
                      children: profileWidgets(),
                    ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("Searched Result for")),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: searchedWidgets(),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  List<Widget> searchedWidgets() {
    List<Widget> searchedTexts = [];
    searchedTexts.add(SizedBox(width: 20));
    for (var search in widget.searchList) {
      if (search['name'] == "user_id" || search['name'] == "gender") {
        continue;
      }
      searchedTexts.add(Container(
        decoration: borderRadius(Colors.pink[50]!, 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            Text(
              search['name'].toString().replaceAll("_", " ").capitalize(),
              style: TextStyle(color: textLightest(), fontSize: 9.5),
            ),
            Text(
              search['value'].toString().replaceAll("_", " ").capitalize(),
              style: TextStyle(
                  color: textMedium(), fontSize: 11, fontFamily: "medium"),
            ),
          ],
        ),
      ));
    }
    searchedTexts.add(SizedBox(width: 20));

    return searchedTexts;
  }

  List<Widget> profileWidgets() {
    List<Widget> profiles = [];
    for (int i = 0; i < profileArray.length; i++) {
      profiles.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ProfileCell(
            profileArray[i],
            width: ((MediaQuery.of(context).size.width) / 2),
          ),
        ),
      );
    }
    return profiles;
  }

  GetValues getValues = new GetValues();
  int page = 1;
  getSearchedData() async {
    loadingState(true);
    widget.searchMap['page_no'] = page.toString();
    dynamic responseData =
        await getValues.advancedSearch(advance_search_url, widget.searchMap);

    // print(responseData.toString());

    if (responseData['success']) {
      profileArray.addAll(responseData['user']);
      page++;
      loadingState(false);
    } else {
      loadingState(false);
      showToast("Something went wrong");
      return [];
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
