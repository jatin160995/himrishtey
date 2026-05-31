import 'package:flutter/material.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:himrishtey/controllers/interests_controller.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';
import 'package:himrishtey/widgets/profile_list_cell.dart';

class Interests extends StatefulWidget {
  const Interests({super.key});

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> with Observer {
  List<bool> switchStatus = [true, false];

  @override
  void initState() {
    Observable.instance.addObserver(this);
    getData();
    super.initState();
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: backgroundColor(),
              appBar: AppBar(
                toolbarHeight: 70,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    headingBig("Interests"),
                    Container(
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ToggleButtons(
                            isSelected: switchStatus,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            selectedColor: primaryColor,
                            selectedBorderColor: primaryColor,
                            fillColor: primaryAccent,
                            onPressed: (int index) {
                              setState(() {
                                switchStatus.setAll(0, [false, false]);
                                switchStatus[index] = true;
                              });
                            },
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Received",
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: "medium"),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Text(
                                  "Sent",
                                  style: TextStyle(
                                      fontSize: 15, fontFamily: "medium"),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                bottom: TabBar(
                  labelColor: primaryColor,
                  indicatorColor: primaryColor,
                  dividerColor: lightBackgroundColor(),
                  labelStyle: TextStyle(fontSize: 15, fontFamily: "medium"),
                  isScrollable: true,
                  automaticIndicatorColorAdjustment: true,
                  tabs: [
                    Tab(child: Text("Pending Interests")),
                    Tab(child: Text("Accepted Interests")),
                    Tab(child: Text("Rejected Interests")),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  switchStatus[0]
                      ? tabView(allInterests['received_interest'])
                      : tabView(allInterests['sentInterest']),
                  switchStatus[0]
                      ? tabView(allInterests['acceptedInterest'])
                      : tabView(allInterests['accepted_sent_interest']),
                  switchStatus[0]
                      ? tabView(allInterests['rejectedInterest'])
                      : tabView(allInterests['rejected_sent_interest']),
                ],
              ),
            ),
          );
  }

  Widget tabView(List interests) {
    //. print(MediaQuery.of(context).size.width - 40);
    // print((MediaQuery.of(context).size.width - 40) / 2);
    interests = interests.reversed.toList();
    return interests.length == 0
        ? Center(child: Text("No data found"))
        : GridView.count(
            primary: false,
            padding: const EdgeInsets.all(7),
            childAspectRatio: (1 / 1.25),
            crossAxisSpacing: 7,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: profileWidgets(interests),
          );
  }

  List<Widget> profileWidgets(List profileArray) {
    List<Widget> profiles = [];
    for (int i = 0; i < profileArray.length; i++) {
      //print("-------" + profileArray[i].toString());
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

  dynamic allInterests = {};
  InterestController interestController = new InterestController();
  bool isLoading = true;

  getData() async {
    dynamic responseData = await interestController.getInterests();
    loadingState(true);
    if (responseData['success']) {
      allInterests = responseData['intrest'];

      loadingState(false);
    } else {
      loadingState(false);
      showToast("No data found");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
