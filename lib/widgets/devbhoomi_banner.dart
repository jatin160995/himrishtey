import 'package:flutter/material.dart';

import 'package:himrishtey/utils/common.dart';
import '../../utils/variables/globals.dart' as globals;

class DevbhoomiBanner extends StatefulWidget {
  const DevbhoomiBanner({super.key});

  @override
  State<DevbhoomiBanner> createState() => _DevbhoomiBannerState();
}

class _DevbhoomiBannerState extends State<DevbhoomiBanner> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: globals.isHimrishtey == 1 ? 0 : 30,
        color: Colors.orange,
        child: globals.isHimrishtey == 1
            ? null
            : Center(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    size: 20,
                    color: white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    globals.isHimrishtey == 1
                        ? "Using DevbhoomiRishtey Version"
                        : "Using DogriRishtey Version",
                    style: TextStyle(
                        color: white, fontSize: 14, fontFamily: "medium"),
                  ),
                ],
              )),
      ),
    );
    ;
  }
}
