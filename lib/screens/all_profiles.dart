import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/get_values.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/utils/variables/shared_prefrences.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class AllProfiles extends StatefulWidget {
  int indentifier;
  AllProfiles(this.indentifier, {super.key});

  @override
  State<AllProfiles> createState() => _AllProfilesState();
}

class _AllProfilesState extends State<AllProfiles> {
  List profileArray = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    // widget.indentifier == 2 ? getData() :
    postData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //print("scroll end");
        // widget.indentifier == 2 ? getData() :
        postData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor(),
        appBar: AppBar(
          title: headingBig(widget.indentifier == 0
              ? "Likes"
              : widget.indentifier == 1
                  ? "Profile visits"
                  : "Viewed by me"),
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
              //  margin: EdgeInsets.only(top: 90),
              child: isLoading && page == 1
                  ? Loader()
                  : profileArray.isEmpty
                      ? Center(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Text(
                              "Profiles not found",
                              style: TextStyle(
                                color: textLightest(),
                                fontSize: 20,
                              ),
                            ),
                          ),
                        )
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
          ],
        ));
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
  postData() async {
    loadingState(true);
    var user_id = await getString(key: userId);
    print({'user_id': user_id, "page_no": page.toString()});
    dynamic responseData = await getValues.getValues(
        widget.indentifier == 0
            ? who_liked_profile_url
            : widget.indentifier == 1
                ? who_viewed_profile_url
                : widget.indentifier == 2
                    ? viewed_by_me_url
                    : viewed_by_me_url,
        {'user_id': user_id, "page_no": page.toString()});

    print(responseData.toString());

    if (responseData['success']) {
      profileArray.addAll(responseData['user']);
      page++;
      loadingState(false);
    } else {
      loadingState(false);
      //profileArray = [];
      //showToast("Something went wrong");
      return [];
    }
  }

  // getData() async {
  //   loadingState(true);
  //   var user_id = await getString(key: userId);
  //   dynamic responseData = await getValues.getValues(
  //       widget.indentifier == 2
  //           ? viewed_by_me_url + "/" + user_id.toString()
  //           : "",
  //       {'page_no': page.toString()});

  //   print(viewed_by_me_url + "/" + user_id.toString());

  //   if (responseData['success']) {
  //     profileArray.addAll(responseData['user']);
  //     page++;
  //     loadingState(false);
  //   } else {
  //     loadingState(false);
  //     profileArray = [];
  //     //showToast("Something went wrong");
  //     return [];
  //   }
  // }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
