import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class QuickSearchResultPage extends StatefulWidget {
  Map searchMap;
  List searchList;
  QuickSearchResultPage(this.searchMap, this.searchList, {super.key});

  @override
  State<QuickSearchResultPage> createState() => _QuickSearchResultPageState();
}

class _QuickSearchResultPageState extends State<QuickSearchResultPage> {
  List profileArray = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getSearchedData();
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
            Container(
              margin: EdgeInsets.only(top: 90),
              child: isLoading
                  ? Loader()
                  : GridView.count(
                      primary: false,
                      padding: const EdgeInsets.all(7),
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
  getSearchedData() async {
    loadingState(true);
    dynamic responseData =
        await getValues.getValues(quick_search_url, widget.searchMap);

    print(responseData.toString());

    if (responseData['success']) {
      profileArray = responseData['user'];
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
