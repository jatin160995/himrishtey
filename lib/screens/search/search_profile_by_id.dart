import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/search_controller.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/widgets/custom_edit_text.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class SearchProfileById extends StatefulWidget {
  const SearchProfileById({super.key});

  @override
  State<SearchProfileById> createState() => _SearchProfileByIdState();
}

class _SearchProfileByIdState extends State<SearchProfileById> {
  TextEditingController profileIdController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Search"),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter profile id",
                style: TextStyle(color: textLightest(), fontSize: 13),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 60,
                decoration: borderRadius(lightBackgroundColor(), 8),
                child: Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: CustomEditText(true, 17, profileIdController,
                            TextInputType.text, "Enter profile id")),
                    Expanded(
                        flex: 2,
                        child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: textDark(),
                          ),
                          onPressed: () {
                            profileRequest();
                          },
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              isLoading
                  ? Loader()
                  : (searchedResult.isEmpty)
                      ? searchedIndex > 0
                          ? Text(
                              "Profile not found",
                              style: TextStyle(
                                  color: textMedium(),
                                  fontSize: 16,
                                  fontFamily: "medium"),
                            )
                          : Container()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Search result for " + profileIdController.text,
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontFamily: "medium",
                                  fontSize: 15),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ProfileCell(searchedResult),
                          ],
                        )
            ],
          ),
        ],
      ),
    );
  }

  int searchedIndex = 0;
  bool isLoading = false;
  SearchProfileController searchProfileController =
      new SearchProfileController();
  dynamic searchedResult = {};
  profileRequest() async {
    if (profileIdController.text == "") {
      showToast("Please fill profile id");
      return;
    }
    loadingState(true);
    searchedResult = {};
    dynamic responseData = await searchProfileController
        .searchProfileById(profileIdController.text);
    loadingState(true);
    if (responseData['success']) {
      searchedResult = responseData['user'];
      print(searchedResult);
      loadingState(false);
    } else {
      // print(searchedResult.toString() + "---------------hello");
      loadingState(false);
      showToast("Profile not found");
    }
    searchedIndex++;
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
