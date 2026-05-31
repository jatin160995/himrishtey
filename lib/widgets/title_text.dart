import 'package:flutter/material.dart';

import '../utils/common.dart';

class TitleText extends StatelessWidget {
  String title;
  String text;

  TitleText(this.title, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: textMedium(), fontSize: 12),
        ),
        Text(
          text,
          style: TextStyle(
              color: textDark(), fontSize: 15.5, fontFamily: "medium"),
        ),
      ],
    );
  }
}
