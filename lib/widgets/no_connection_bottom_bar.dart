import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';
import '../../utils/variables/globals.dart' as globals;

class NoConnectionBottomBar extends StatelessWidget {
  const NoConnectionBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: globals.isConnected ? 0 : 30,
      color: Colors.red,
      child: globals.isConnected
          ? null
          : Center(
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.signal_wifi_connected_no_internet_4_rounded,
                  size: 20,
                  color: white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "No internet connection",
                  style: TextStyle(
                      color: white, fontSize: 14, fontFamily: "medium"),
                ),
              ],
            )),
    );
  }
}
