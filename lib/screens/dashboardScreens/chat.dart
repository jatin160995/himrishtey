import 'package:flutter/material.dart';
import 'package:himrishtey/utils/common.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor(),
      appBar: AppBar(
        title: headingBig("Chats"),
      ),
      body: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat,
                color: primaryAccent,
                size: 80,
              ),
              heading("Coming Soon"),
              Text(
                "Chat feature will be introduced soon.",
                style: TextStyle(color: textLightest(), fontSize: 14),
              ),
            ],
          )),
    );
  }
}
