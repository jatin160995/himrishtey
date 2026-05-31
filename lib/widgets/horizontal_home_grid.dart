import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:himrishtey/controllers/home_controller.dart';
import 'package:himrishtey/screens/view_all_profiles.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/variables/api_endpoints.dart';
import 'package:himrishtey/widgets/button_loader.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class HorizontalHomeGrid extends StatefulWidget {
  String title;
  String url;
  HorizontalHomeGrid(this.title, this.url, {super.key});

  @override
  State<HorizontalHomeGrid> createState() => _HorizontalHomeGridState();
}

class _HorizontalHomeGridState extends State<HorizontalHomeGrid> with Observer {
  @override
  void initState() {
    Observable.instance.addObserver(this);
    recentProfiles();
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    print(widget.title);
    print(widget.url);
    recentProfiles();
  }

  @override
  Widget build(BuildContext context) {
    print(recentProfilesArray);
    return Container(
      // margin: EdgeInsets.only(top: 20),
      width: double.infinity,
      child: recentProfilesArray.isEmpty && !isLoading
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      heading(widget.title),
                      isLoading
                          ? Container()
                          : TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewAll(
                                            widget.title,
                                            recentProfilesArray,
                                            widget.url,
                                          )),
                                );
                              },
                              child: Text(
                                "View All",
                                style: TextStyle(
                                    color: textMedium(), fontFamily: "medium"),
                              ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.6,
                  child: isLoading
                      ? Center(
                          child: Loader(),
                        )
                      : recentProfilesArray.isEmpty
                          ? Container(
                              margin: EdgeInsets.only(top: 20, left: 20),
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: textLightest(),
                                  fontSize: 20,
                                ),
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: recentProfilesArray.length > 10
                                  ? 10
                                  : recentProfilesArray.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: 14, left: index == 0 ? 20 : 0),
                                  child:
                                      ProfileCell(recentProfilesArray[index]),
                                );
                              }),
                )
              ],
            ),
    );
  }

  HomeController homeController = new HomeController();
  bool isLoading = false;
  List recentProfilesArray = [];
  String message = "";
  recentProfiles() async {
    loadingState(true);
    dynamic responseData = await homeController.getProfiles(widget.url, "1");
    print(widget.url);
    print(responseData);
    if (responseData['success']) {
      recentProfilesArray = responseData['user'];
      // recentProfilesArray = recentProfilesArray.reversed.toList();
      loadingState(false);
    } else {
      recentProfilesArray = [];
      message = responseData['message'];
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
