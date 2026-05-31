import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/controllers/home_controller.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/widgets/loader.dart';
import 'package:himrishtey/widgets/profile_cell.dart';

class ViewedContacts extends StatefulWidget {
  String title;
  String url;
  ViewedContacts(this.title, this.url, {super.key});

  @override
  State<ViewedContacts> createState() => _ViewedContactsState();
}

class _ViewedContactsState extends State<ViewedContacts> {
  List profileArray = [];

  @override
  void initState() {
    recentProfiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor(),
        appBar: AppBar(
          title: headingBig(widget.title),
        ),
        body: isLoading
            ? Center(
                child: Loader(),
              )
            : profileArray.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 20, left: 20),
                    child: Text(
                      "Profiles not found",
                      style: TextStyle(
                        color: textLightest(),
                        fontSize: 20,
                      ),
                    ),
                  )
                : GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(7),
                    childAspectRatio: (1 / 1.25),
                    crossAxisSpacing: 7,
                    mainAxisSpacing: 5,
                    crossAxisCount: 2,
                    children: profileWidgets(),
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

  HomeController homeController = new HomeController();
  bool isLoading = false;

  String message = "";
  recentProfiles() async {
    loadingState(true);

    dynamic responseData = await homeController.getProfiles(widget.url, "1");

    if (responseData['success']) {
      profileArray = responseData['user'];
      loadingState(false);
    } else {
      profileArray = [];
      message = responseData['message'];
      loadingState(false);

      showToast("No profile found");
    }
  }

  loadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }
}
