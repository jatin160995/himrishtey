import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/home_controller.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class ViewAll extends StatefulWidget {
  String title;
  dynamic profileArray;
  String url;

  ViewAll(this.title, this.profileArray, this.url, {super.key});

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  List _profileArray = [];
  int page = 0;
  @override
  void initState() {
    super.initState();
    _profileArray = widget.profileArray;
    page = ((_profileArray.length) / 10).round();
    print(page);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //print("scroll end");
        recentProfiles();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor(),
        appBar: AppBar(
          title: headingBig(widget.title),
        ),
        body: Stack(
          children: [
            GridView.count(
              controller: _scrollController,
              primary: false,
              padding: EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 70),
              childAspectRatio: (1 / 1.25),
              crossAxisSpacing: 7,
              mainAxisSpacing: 5,
              crossAxisCount: 2,
              children: profileWidgets(),
            ),
            isLoading
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
                : Container()
          ],
        )
        //  ListView(
        //   padding: EdgeInsets.symmetric(vertical: 7.5),
        //   children: [
        //     Container(
        //       padding: EdgeInsets.symmetric(horizontal: 7.5),
        //       child: Wrap(
        //         children: profileWidgets(),
        //       ),
        //     )
        //   ],
        // ),
        );
  }

  List<Widget> profileWidgets() {
    List<Widget> profiles = [];
    for (int i = 0; i < _profileArray.length; i++) {
      profiles.add(
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: ProfileCell(
            _profileArray[i],
            width: ((MediaQuery.of(context).size.width) / 2),
          ),
        ),
      );
    }
    return profiles;
  }

  HomeController homeController = new HomeController();
  recentProfiles() async {
    if (isLoading) {
      return;
    }
    print("called");
    loadingState(true);
    ++page;
    dynamic responseData =
        await homeController.getProfiles(widget.url, (page).toString());
    print(widget.url);
    print(responseData);
    if (responseData['success']) {
      _profileArray.addAll(responseData['user']);
      // recentProfilesArray = recentProfilesArray.reversed.toList();
      loadingState(false);
    } else {
      // recentProfilesArray = [];
      //message = responseData['message'];
      loadingState(false);

      // showToast(widget.title + " Not found");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
