import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import 'package:himrishtey/utils/container_radius.dart';

class BannedUser extends StatefulWidget {
  const BannedUser({super.key});

  @override
  State<BannedUser> createState() => _BannedUserState();
}

class _BannedUserState extends State<BannedUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Align(
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Banned Profile",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "You are banned by our team. To get unbanned and use our services, please contact our team. We hope this will be solved soon. Thanks for choosing us.\n Contact no. - 9857102002",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: textDark(), fontSize: 15, fontFamily: "medium"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              child: Column(
                children: [
                  Container(
                    decoration: borderRadius(textDark(), 10),
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      logo,
                      height: 40,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
